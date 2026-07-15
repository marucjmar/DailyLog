defmodule CodeRunner do
  @moduledoc """
  Uruchamia skrypty Deno w Dockerze w trybie strumieniowym (NDJSON po stdin/stdout).

  Protokół (Elixir -> Deno, po stdin):
    {"type":"execute","fn":"connect","ctx":{...}}      # pierwsza wiadomość, startuje wykonanie
    {"type":"input_response","id":"...","data":...}    # odpowiedź na request_input

  Protokół (Deno -> Elixir, po stdout, jedna linia = jeden komunikat):
    {"type":"progress","data":...}
    {"type":"request_input","id":"...","schema":...}
    {"type":"done","result":...}
    {"type":"error","message":"...","stack":"..."}
  """

  @deno_image "denoland/deno:alpine"

  # -------------------------
  # Bundling (bez zmian)
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
  # Streaming run
  # -------------------------

  @doc """
  Uruchamia proces Deno gotowy na przyjęcie komendy `execute`.
  Zwraca `{:ok, %{port: port, tmp_files: [...]}}` - proces CZEKA na stdin,
  nic się jeszcze nie wykonuje, dopóki nie wyślesz `execute/3`.
  """
  def run_file(path) do
    File.read!(path) |> start()
  end

  def start(code) when is_binary(code) do
    id = :crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower)

    file = Path.join(System.tmp_dir!(), "#{id}.ts")
    wrapper_path = Path.join(System.tmp_dir!(), "#{id}-wrap.ts")

    File.write!(file, code)
    File.write!(wrapper_path, wrapper())

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

  @doc "Wysyła komendę startową - jaką funkcję wywołać i z jakim kontekstem."
  def execute(port, fn_name, ctx) do
    payload = Jason.encode!(%{type: "execute", fn: fn_name, ctx: ctx}) <> "\n"
    Port.command(port, payload)
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
  # Prosty tryb synchroniczny (bez obsługi request_input)
  # -------------------------

  @doc """
  Wygodny helper dla skryptów, które NIE potrzebują request_input.
  Startuje proces, od razu wysyła `execute` i blokuje do wyniku.
  """
  def run(code, fn_name, ctx, timeout \\ 500_000) when is_binary(code) do
    {:ok, %{port: port, tmp_files: tmp_files}} = start(code)
    execute(port, fn_name, ctx)

    result = collect(port, timeout)
    cleanup(tmp_files)
    result
  end

  def run_file_sync(path, fn_name, ctx, timeout \\ 500_000) do
    File.read!(path) |> run(fn_name, ctx, timeout)
  end

  defp collect(port, timeout) do
    receive do
      {^port, {:data, {:eol, line}}} ->
        case decode_line(line) do
          {:ok, %{"type" => "progress"}} ->
            collect(port, timeout)

          {:ok, %{"type" => "request_input"}} ->
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
  # Wrapper Deno - czeka na komendę `execute` po stdin
  # -------------------------

  defp wrapper do
    """
    const encoder = new TextEncoder();
    const pending = new Map();
    let buffer = "";
    let started = false;

    function send(msg) {
      Deno.stdout.writeSync(encoder.encode(JSON.stringify(msg) + "\\n"));
    }

    function progress(data) {
      send({ type: "progress", data });
    }

    function requestInput(schema) {
      const id = crypto.randomUUID();
      send({ type: "request_input", id, schema });
      return new Promise((resolve) => pending.set(id, resolve));
    }

    async function runExecute({ fn: fnName, ctx }) {
      try {
        const mod = await import("./code.ts");

        if (typeof mod[fnName] !== "function") {
          send({
            type: "error",
            message: `Export "${fnName}" nie istnieje lub nie jest funkcją w tym module.`,
          });
          Deno.exit(1);
        }

        const result = await mod[fnName](ctx, { progress, requestInput });
        send({ type: "done", result });
        Deno.exit(0);
      } catch (err) {
        send({ type: "error", message: err.message, stack: err.stack });
        Deno.exit(1);
      }
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

          let msg;
          try {
            msg = JSON.parse(line);
          } catch {
            continue; // ignoruj niepoprawne linie
          }

          if (msg.type === "execute" && !started) {
            started = true;
            runExecute(msg); // celowo bez await - nie blokuj pętli czytania stdin
          } else if (msg.type === "input_response" && pending.has(msg.id)) {
            pending.get(msg.id)(msg.data);
            pending.delete(msg.id);
          }
        }
      }
    }

    readStdinLoop();
    """
  end
end
