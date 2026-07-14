defmodule BackendWeb.API.IntegrationsController do
  use BackendWeb, :controller
  import Phoenix.LiveView.Controller

  alias Backend.Integrations
  alias BackendWeb.API.GarminIntegrationLive

  def connect(conn, %{"integration" => integration}) do
    case integration do
      "garmin" ->
        live_render(conn, GarminIntegrationLive, session: %{})

      _ ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Integration not found"})
    end
  end
end
