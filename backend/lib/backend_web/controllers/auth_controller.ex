defmodule BackendWeb.AuthController do
  use BackendWeb, :controller

  alias Backend.Accounts

  def register(conn, %{"email" => email, "password" => password}) do
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

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        token = Accounts.generate_token(user)
        json(conn, %{token: token, user: user})

      :error ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "invalid credentials"})
    end
  end
end
