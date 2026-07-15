defmodule Backend.Integrations.IntegrationDispatcherWorker do
  use Oban.Worker, queue: :scheduler

  import Ecto.Query

  alias Backend.Repo
  alias Backend.Integrations.Integration
  alias Backend.Integrations.SyncIntegrationWorker

  require Logger

  @impl Oban.Worker
  def perform(job) do
    now = DateTime.utc_now()

    integrations =
      from(i in Integration,
        where: i.enabled == true,
        where: i.next_sync_at <= ^now
      )
      |> Repo.all()

    Logger.info("Found #{length(integrations)} integrations to sync")

    Enum.each(integrations, fn integration ->
      %{"integration_id" => integration.id}
      |> SyncIntegrationWorker.new(queue: :integrations)
      |> Oban.insert()
    end)

    :ok
  end

  def enqueue_once do
    %{}
    |> new(queue: :scheduler)
    |> Oban.insert()
  end
end
