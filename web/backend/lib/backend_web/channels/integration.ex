defmodule BackendWeb.API.IntegrationChannel do
  use BackendWeb, :channel

  @impl true
  def join("integration:" <> integration, _payload, socket) do
    {:ok, %{status: "connected"},
     socket
     |> assign(:integration, integration)
     |> assign(:executions, %{})   # client id -> %{port, tmp_files}
     |> assign(:ports, %{})}       # port -> client id
  end

  @impl true
  def terminate(_reason, socket) do
    socket.assigns.executions
    |> Map.values()
    |> Enum.each(fn %{port: port, tmp_files: tmp_files} ->
      safe_close_port(port)
      CodeRunner.cleanup(tmp_files)
    end)

    :ok
  end

  @impl true
  def handle_in("execute", %{"id" => id, "function" => fn_name, "payload" => payload}, socket) do
    path =
      "/Users/marcin/development/daily-log/web/backend/lib/backend/integrations/js/templates/#{socket.assigns.integration}/connect.ts"

    {:ok, %{port: port, tmp_files: tmp_files}} = CodeRunner.run_file(path)
    CodeRunner.execute(port, fn_name, payload)

    socket =
      socket
      |> put_execution(id, %{port: port, tmp_files: tmp_files})
      |> put_port(port, id)

    {:reply, {:ok, %{id: id}}, socket}
  end

  @impl true
  def handle_in(
        "submit_input",
        %{"execution_id" => execution_id, "id" => input_id, "inputs" => inputs},
        socket
      ) do
    case get_execution(socket, execution_id) do
      %{port: port} ->
        CodeRunner.submit_input(port, input_id, inputs)
        {:reply, {:ok, %{}}, socket}

      nil ->
        {:reply, {:error, %{reason: "unknown_execution"}}, socket}
    end
  end

    @impl true
  def handle_in(
        "terminate_execution",
        %{"id" => execution_id },
        socket
      ) do
    case get_execution(socket, execution_id) do
      %{port: port} ->
        safe_close_port(port)

        {:reply, {:ok, %{}}, socket}

      nil ->
        {:reply, {:error, %{reason: "unknown_execution"}}, socket}
    end
  end

  @impl true
  def handle_info({port, {:data, {:eol, line}}}, socket) do
    case Map.get(socket.assigns.ports, port) do
      nil -> {:noreply, socket}
      id -> handle_line(CodeRunner.decode_line(line), id, socket)
    end
  end

  @impl true
  def handle_info({port, {:exit_status, status}}, socket) do
    case Map.get(socket.assigns.ports, port) do
      nil ->
        {:noreply, socket}

      id ->
        push(socket, "exit", %{id: id, status: status})
        {:noreply, drop_execution(socket, id)}
    end
  end

  # -------------------------
  # Routing pojedynczej linii NDJSON do właściwego execution id
  # -------------------------

  defp handle_line({:ok, %{"type" => "progress"} = msg}, id, socket) do
    push(socket, "progress", Map.put(msg, "id", id))
    {:noreply, socket}
  end

  defp handle_line({:ok, %{"type" => "request_input"} = msg}, id, socket) do
    push(socket, "request_input", Map.put(msg, "execution_id", id))
    {:noreply, socket}
  end

  defp handle_line({:ok, %{"type" => "done", "result" => result}}, id, socket) do
    push(socket, "done", %{id: id, result: result})
    {:noreply, drop_execution(socket, id)}
  end

  defp handle_line({:ok, %{"type" => "error"} = msg}, id, socket) do
    push(socket, "error", Map.put(msg, "id", id))
    {:noreply, drop_execution(socket, id)}
  end

  defp handle_line({:error, _reason}, _id, socket), do: {:noreply, socket}

  # -------------------------
  # Zarządzanie stanem wielu równoległych wykonań
  # -------------------------

  defp put_execution(socket, id, data),
    do: assign(socket, :executions, Map.put(socket.assigns.executions, id, data))

  defp put_port(socket, port, id),
    do: assign(socket, :ports, Map.put(socket.assigns.ports, port, id))

  defp get_execution(socket, id), do: Map.get(socket.assigns.executions, id)

  defp drop_execution(socket, id) do
    case get_execution(socket, id) do
      nil ->
        socket

      %{port: port, tmp_files: tmp_files} ->
        CodeRunner.cleanup(tmp_files)

        socket
        |> assign(:executions, Map.delete(socket.assigns.executions, id))
        |> assign(:ports, Map.delete(socket.assigns.ports, port))
    end
  end

  defp safe_close_port(port) do
    if Port.info(port) != nil do
        Port.close(port)
      end
    rescue
      ArgumentError -> :ok
    end
end
