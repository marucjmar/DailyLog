defmodule Backend.Integrations do
  @moduledoc """
  The Integrations context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Integrations.Integration
  alias Backend.Integrations.IntegrationTemplate
  alias Backend.Integrations.SyncIntegrationWorker
  alias Backend.Integrations.SyncLog

  @doc """
  Returns the list of integrations.

  ## Examples

      iex> list_integrations()
      [%Integration{}, ...]

  """
  def list_integrations do
    Repo.all(Integration)
  end

  @doc """
  Gets a single integration.

  Raises `Ecto.NoResultsError` if the Integration does not exist.

  ## Examples

      iex> get_integration!(123)
      %Integration{}

      iex> get_integration!(456)
      ** (Ecto.NoResultsError)

  """
  def get_integration!(id), do: Repo.get!(Integration, id)

  def get_integration(id), do: Repo.get(Integration, id)

  @doc """
  Creates a integration.

  ## Examples

      iex> create_integration(%{field: value})
      {:ok, %Integration{}}

      iex> create_integration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_integration(attrs) do
    alias Ecto.Multi

    Multi.new()
    |> Multi.insert(:integration, Integration.changeset(%Integration{}, attrs))
    |> Multi.run(:enqueue_sync, fn _repo, %{integration: integration} ->
      SyncIntegrationWorker.enqueue(integration.id)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a integration.

  ## Examples

      iex> update_integration(integration, %{field: new_value})
      {:ok, %Integration{}}

      iex> update_integration(integration, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_integration(%Integration{} = integration, attrs) do
    integration
    |> Integration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a integration.

  ## Examples

      iex> delete_integration(integration)
      {:ok, %Integration{}}

      iex> delete_integration(integration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_integration(%Integration{} = integration) do
    Repo.delete(integration)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking integration changes.

  ## Examples

      iex> change_integration(integration)
      %Ecto.Changeset{data: %Integration{}}

  """
  def change_integration(%Integration{} = integration, attrs \\ %{}) do
    Integration.changeset(integration, attrs)
  end

  def sync(%Integration{} = integration, ctx = %{trigger: "daily_sync"}) do
    started_at = System.monotonic_time(:millisecond)

    ctxi =
      Map.merge(ctx, %{
        inputs: integration.inputs,
        date: Date.to_iso8601(integration.next_sync_at)
      })

    # zamienić na Coderunner z dockera
    {result, events} =
      case NodeJS.call({integration.compiled_path, "sync"}, [ctxi]) do
        {:ok, output} ->
          case Jason.decode(output) do
            {:ok, data} -> {:ok, data}
            {:error, error} -> {:error, error.data}
          end

        {:error, error} ->
          {:error, error}
      end

    duration_ms = System.monotonic_time(:millisecond) - started_at

    case result do
      :ok ->
        events
        |> Enum.map(fn event -> Map.put(event, "user_id", 1) end)
        |> Backend.Journal.create_events()
        |> IO.inspect()

        %SyncLog{}
        |> SyncLog.changeset(%{
          connection_id: integration.id,
          status: :ok,
          duration_ms: duration_ms,
          events_count: length(events)
        })
        |> Repo.insert!()

        {:ok, events}

      :error ->
        %SyncLog{}
        |> SyncLog.changeset(%{
          connection_id: integration.id,
          status: :error,
          duration_ms: duration_ms,
          events_count: 0,
          error: String.slice(events, 0, 500)
        })
        |> Repo.insert!()

        {:error, events}
    end
  end

  # defp run_template(%Integration{} = integration) do
  #   payload = Jason.encode!(integration.config)

  #   System.cmd(
  #     "node",
  #     [
  #       "runtime/execute.js",
  #       "dist/plugins/garmin.js",
  #       payload
  #     ]
  #   )

  #   {json, 0} =
  #     System.cmd(
  #       "node",
  #       [
  #         "runtime/execute.js",
  #         "dist/plugins/#{plugin}.js"
  #       ],
  #       stderr_to_stdout: true
  #     )

  #   Jason.decode!(json)
  # end

  @doc """
  Returns the list of integration_templates.

  ## Examples

      iex> list_integration_templates()
      [%IntegrationTemplate{}, ...]

  """
  def list_integration_templates do
    Repo.all(IntegrationTemplate)
  end

  @doc """
  Gets a single integration_template.

  Raises `Ecto.NoResultsError` if the Integration template does not exist.

  ## Examples

      iex> get_integration_template!(123)
      %IntegrationTemplate{}

      iex> get_integration_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_integration_template!(id), do: Repo.get!(IntegrationTemplate, id)

  @doc """
  Creates a integration_template.

  ## Examples

      iex> create_integration_template(%{field: value})
      {:ok, %IntegrationTemplate{}}

      iex> create_integration_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_integration_template(attrs) do
    %IntegrationTemplate{}
    |> IntegrationTemplate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a integration_template.

  ## Examples

      iex> update_integration_template(integration_template, %{field: new_value})
      {:ok, %IntegrationTemplate{}}

      iex> update_integration_template(integration_template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_integration_template(%IntegrationTemplate{} = integration_template, attrs) do
    integration_template
    |> IntegrationTemplate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a integration_template.

  ## Examples

      iex> delete_integration_template(integration_template)
      {:ok, %IntegrationTemplate{}}

      iex> delete_integration_template(integration_template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_integration_template(%IntegrationTemplate{} = integration_template) do
    Repo.delete(integration_template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking integration_template changes.

  ## Examples

      iex> change_integration_template(integration_template)
      %Ecto.Changeset{data: %IntegrationTemplate{}}

  """
  def change_integration_template(%IntegrationTemplate{} = integration_template, attrs \\ %{}) do
    IntegrationTemplate.changeset(integration_template, attrs)
  end

  alias Backend.Integrations.Integration

  @doc """
  Returns the list of connections.

  ## Examples

      iex> list_connections()
      [%Integration{}, ...]

  """
  def list_connections do
    Repo.all(Integration)
  end

  @doc """
  Gets a single connection.

  Raises `Ecto.NoResultsError` if the Integration does not exist.

  ## Examples

      iex> get_connection!(123)
      %Integration{}

      iex> get_connection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_connection!(id), do: Repo.get!(Integration, id)

  @doc """
  Creates a connection.

  ## Examples

      iex> create_connection(%{field: value})
      {:ok, %Integration{}}

      iex> create_connection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_connection(attrs) do
    %Integration{}
    |> Integration.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a connection.

  ## Examples

      iex> update_connection(connection, %{field: new_value})
      {:ok, %Integration{}}

      iex> update_connection(connection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_connection(%Integration{} = connection, attrs) do
    connection
    |> Integration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a connection.

  ## Examples

      iex> delete_connection(connection)
      {:ok, %Integration{}}

      iex> delete_connection(connection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_connection(%Integration{} = connection) do
    Repo.delete(connection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking connection changes.

  ## Examples

      iex> change_connection(connection)
      %Ecto.Changeset{data: %Integration{}}

  """
  def change_connection(%Integration{} = connection, attrs \\ %{}) do
    Integration.changeset(connection, attrs)
  end

  alias Backend.Integrations.SyncLog

  @doc """
  Returns the list of sync_logs.

  ## Examples

      iex> list_sync_logs()
      [%SyncLog{}, ...]

  """
  def list_sync_logs do
    Repo.all(SyncLog)
  end

  @doc """
  Gets a single sync_log.

  Raises `Ecto.NoResultsError` if the Sync log does not exist.

  ## Examples

      iex> get_sync_log!(123)
      %SyncLog{}

      iex> get_sync_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sync_log!(id), do: Repo.get!(SyncLog, id)

  @doc """
  Creates a sync_log.

  ## Examples

      iex> create_sync_log(%{field: value})
      {:ok, %SyncLog{}}

      iex> create_sync_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sync_log(attrs) do
    %SyncLog{}
    |> SyncLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sync_log.

  ## Examples

      iex> update_sync_log(sync_log, %{field: new_value})
      {:ok, %SyncLog{}}

      iex> update_sync_log(sync_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sync_log(%SyncLog{} = sync_log, attrs) do
    sync_log
    |> SyncLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sync_log.

  ## Examples

      iex> delete_sync_log(sync_log)
      {:ok, %SyncLog{}}

      iex> delete_sync_log(sync_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sync_log(%SyncLog{} = sync_log) do
    Repo.delete(sync_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sync_log changes.

  ## Examples

      iex> change_sync_log(sync_log)
      %Ecto.Changeset{data: %SyncLog{}}

  """
  def change_sync_log(%SyncLog{} = sync_log, attrs \\ %{}) do
    SyncLog.changeset(sync_log, attrs)
  end
end
