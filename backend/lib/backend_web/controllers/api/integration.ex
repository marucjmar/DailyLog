defmodule BackendWeb.API.IntegrationsController do
  use BackendWeb, :controller

  def connect(conn, %{"integration" => integration}) do
    integration = String.downcase(integration)

    case integration do
      "garmin" ->
        html(conn, File.read!("/Users/marcin/development/daily-log/backend/lib/backend_web/controllers/api/integrations_html/connect.html"))

      _ ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Integration not found"})
    end
  end
end
