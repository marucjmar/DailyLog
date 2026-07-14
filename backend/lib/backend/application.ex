defmodule Backend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BackendWeb.Telemetry,
      Backend.Repo,
      {Oban,
       AshOban.config(
         Application.fetch_env!(:backend, :ash_domains),
         Application.fetch_env!(:backend, Oban)
       )},
      # Start a worker by calling: Backend.Worker.start_link(arg)
      # {Backend.Worker, arg},
      # Start to serve requests, typically the last entry
      {DNSCluster, query: Application.get_env(:backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Backend.PubSub},
      BackendWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :backend]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Backend.Supervisor]
    result = Supervisor.start_link(children, opts)

    case result do
      {:ok, _pid} ->
        Backend.Integrations.IntegrationDispatcherWorker.enqueue_once()

      _ ->
        result
    end

    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
