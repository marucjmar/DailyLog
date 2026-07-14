defmodule BackendWeb.API.AuthController do
  use BackendWeb, :controller

  alias Backend.Accounts

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.register_user(email, password) do
      {:ok, user} ->
        token = Accounts.generate_token(user)
        json(conn, %{token: token, user: user})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset})
    end
  end
end
