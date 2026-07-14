defmodule Backend.Integrations.SyncIntegrationWorker do
  use Oban.Worker, queue: :integrations, max_attempts: 5

  alias Backend.Integrations
  alias Backend.Journal
  alias Backend.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"integration_id" => id}}) do
    case Integrations.get_integration(id) do
      nil ->
        # rekord nie istnieje → koniec joba bez retry
        :ok

      integration ->
        case Integrations.sync(integration) do
          {:ok, events} ->
            Enum.each(events, &Journal.create_event/1)
            update_next_sync(integration)
            :ok

          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  defp update_next_sync(integration) do
    interval =
      integration.sync_interval_minutes || 60

    next_sync_at =
      DateTime.utc_now()
      |> DateTime.add(interval * 60, :second)
      |> DateTime.truncate(:second)

    integration
    |> Ecto.Changeset.change(%{next_sync_at: next_sync_at})
    |> Repo.update()
  end

  def enqueue(integration_id) do
    %{"integration_id" => integration_id}
    |> new()
    |> Oban.insert()
  end
end
