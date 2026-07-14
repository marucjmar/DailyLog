defmodule CodeRunner do
  @moduledoc """
  Uruchamia skrypty Deno w Dockerze w trybie strumieniowym (NDJSON po stdin/stdout).

  Protokół (Node/Deno -> Elixir, po jednej linii JSON na stdout):
    {"type":"progress","data":...}
    {"type":"request_input","id":"...","schema":...}
    {"type":"done","result":...}
    {"type":"error","message":"...","stack":"..."}

  Protokół (Elixir -> Deno, po stdin):
    {"type":"input_response","id":"...","data":...}
  """

  @deno_image "denoland/deno:alpine"

  # -------------------------
  # Bundling (bez zmian - jednorazowe, nieinteraktywne)
  # -------------------------

  def build(path) do
    home = System.user_home!()

    args = [
      "run", "--rm",
      "--memory", "512m", "--memory-swap", "512m", "--cpus", "1", "--pids-limit", "64",
      "-v", "#{path}:/app/code.ts",
      "-v", "#{home}/.deno:/deno-dir",
      @deno_image,
      "deno", "bundle", "--minify", "--platform=browser", "/app/code.ts"
    ]

    case System.cmd("docker", args, stderr_to_stdout: false) do
      {out, 0} -> {:ok, out}
      {out, _} -> {:error, out}
    end
  end

  # -------------------------
  # Streaming run - zwraca Port, wiadomości lecą do skrzynki wywołującego
  # -------------------------

  @doc """
  Uruchamia skrypt jako proces strumieniowy. Zwraca `{:ok, %{port: port, tmp_files: [...]}}`.

  Wywołujący proces dostaje w swojej skrzynce standardowe wiadomości portu:
    {port, {:data, {:eol, line}}}
    {port, {:exit_status, status}}

  Użyj `CodeRunner.decode_line/1` do sparsowania linii i `CodeRunner.submit_input/3`
  żeby odpowiedzieć na `request_input`.
  """
  def run_file(path, ctx, fn_name \\ "main") do
    File.read!(path) |> start(ctx, fn_name)
  end

  def run_file_sync(path, ctx, fn_name \\ "main") do
    File.read!(path)
    |> run(ctx, fn_name)
  end

  def start(code, ctx, fn_name) when is_binary(code) do
    id = :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)

    file = Path.join(System.tmp_dir!(), "#{id}.ts")
    wrapper_path = Path.join(System.tmp_dir!(), "#{id}-wrap.ts")

    File.write!(file, code)
    File.write!(wrapper_path, wrapper(ctx, fn_name))

    home = System.user_home!()

    args = [
      "run", "-i", "--rm",
      "--memory", "512m", "--memory-swap", "512m", "--cpus", "1", "--pids-limit", "64",
      "-v", "#{file}:/app/code.ts",
      "-v", "#{wrapper_path}:/app/code-wrap.ts",
      "-v", "#{home}/.deno:/deno-dir",
      @deno_image,
      "deno", "run", "-A", "/app/code-wrap.ts"
    ]

    port =
      Port.open({:spawn_executable, System.find_executable("docker")}, [
        :binary,
        :exit_status,
        {:line, 65_536},
        args: args
      ])

    {:ok, %{port: port, tmp_files: [file, wrapper_path]}}
  end

  @doc "Parsuje pojedynczą linię NDJSON przychodzącą z portu."
  def decode_line(line), do: Jason.decode(line)

  @doc "Odpowiada na request_input wysłany przez skrypt."
  def submit_input(port, id, data) do
    payload = Jason.encode!(%{type: "input_response", id: id, data: data}) <> "\n"
    Port.command(port, payload)
  end

  @doc "Sprząta pliki tymczasowe po zakończeniu (wywołaj po :done/:error/:exit_status)."
  def cleanup(tmp_files) do
    Enum.each(tmp_files, &File.rm/1)
  end

  # -------------------------
  # Prosty tryb synchroniczny (dla przypadków bez request_input, np. skrypty batch)
  # -------------------------

  @doc """
  Wygodny helper dla skryptów, które NIE potrzebują request_input - blokuje
  do :done/:error/:exit_status. Nie używaj tego, jeśli skrypt może pytać o dane
  (np. Garmin MFA) - wtedy steruj portem ręcznie w swoim GenServerze/gen_statem.
  """
  def run(code, ctx, fn_name \\ "sync", timeout \\ 500_000) when is_binary(code) do
    {:ok, %{port: port, tmp_files: tmp_files}} = start(code, ctx, fn_name)

    result = collect(port, timeout)
    cleanup(tmp_files)
    result
  end

  defp collect(port, timeout) do
    receive do
      {^port, {:data, {:eol, line}}} ->
        case decode_line(line) do
          {:ok, %{"type" => "progress"}} ->
            collect(port, timeout)

          {:ok, %{"type" => "request_input"}} ->
            # W trybie sync nie ma jak odpowiedzieć - to błąd użycia.
            {:error, :requires_interactive_mode}

          {:ok, %{"type" => "done", "result" => result}} ->
            %{status: "ok", result: result}

          {:ok, %{"type" => "error"} = err} ->
            %{status: "error", error: err}

          {:error, _} ->
            collect(port, timeout)
        end

      {^port, {:exit_status, status}} ->
        %{status: "error", error: "process exited with #{status}"}
    after
      timeout ->
        Port.close(port)
        %{status: "error", error: "timeout"}
    end
  end

  # -------------------------
  # Wrapper Deno z obsługą request_input po stdin
  # -------------------------

  defp wrapper(ctx, fn_name) do
    ctx_json = Jason.encode!(ctx)

    """
    const encoder = new TextEncoder();
    const pending = new Map();
    let buffer = "";

    function send(msg) {
      Deno.stdout.writeSync(encoder.encode(JSON.stringify(msg) + "\\n"));
    }

    function progress(data) {
      send({ type: "progress", data });
    }

    function requestInput(schema) {
      const id = crypto.randomUUID();
      send({ type: "request_input", id, schema });
      return new Promise((resolve) => pending.set(schema, resolve));
    }

    async function readStdinLoop() {
      const decoder = new TextDecoder();
      for await (const chunk of Deno.stdin.readable) {
        buffer += decoder.decode(chunk, { stream: true });
        let idx;
        while ((idx = buffer.indexOf("\\n")) >= 0) {
          const line = buffer.slice(0, idx);
          buffer = buffer.slice(idx + 1);
          if (!line.trim()) continue;
          try {
            const msg = JSON.parse(line);
            Deno.stderr.write(encoder.encode("Received message: " + JSON.stringify(msg) + "\\n"));

            if (msg.type === "input_response" && pending.has(msg.id)) {
              pending.get(msg.id)(msg.data);
              pending.delete(msg.id);
            }
          } catch {
            // ignoruj niepoprawne linie
          }
        }
      }
    }

    readStdinLoop();

    (async () => {
      const io = { progress, requestInput };
      const fnName = '#{fn_name}';


      try {
       const mod = await import("./code.ts");

        if (typeof mod[fnName] !== "function") {
          send({
            type: "error",
            message: `Export "${fnName}" nie istnieje lub nie jest funkcją w tym module.`,
          });
          Deno.exit(1);
        }

        const result = await mod[fnName](#{ctx_json}, io);
        send({ type: "done", result });
      } catch (err) {
        send({ type: "error", message: err.message, stack: err.stack });
        Deno.exit(1);
      }

      Deno.exit(0);
    })();
    """
  end
end
