defmodule Backend.Accounts.Session do
  use Ash.Resource,
    otp_app: :backend,
    domain: Backend.Accounts,
    data_layer: :embedded,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshJsonApi.Resource]

  json_api do
    type "session"

    routes do
      base "/sessions"

      post :sign_in_with_password do
        route "/password"
      end
    end
  end

  actions do
    action :sign_in_with_password, :struct do
      constraints instance_of: __MODULE__

      argument :email, :ci_string do
        allow_nil? false
      end

      argument :password, :string do
        allow_nil? false
        sensitive? true
      end

      run fn input, context ->
        query =
          Backend.Accounts.User
          |> Ash.Query.for_read(
            :sign_in_with_password,
            %{
              email: input.arguments.email,
              password: input.arguments.password
            }
          )

        case Ash.read_one(query, actor: context.actor) do
          {:ok, nil} ->
            {:error, "Invalid email or password"}

          {:ok, user} ->
            {:ok,
             %__MODULE__{
               id: Ash.UUID.generate(),
               access_token: user.__metadata__.token,
               user_id: user.id
             }}

          {:error, error} ->
            {:error, error}
        end
      end
    end
  end

  policies do
    policy action(:sign_in_with_password) do
      authorize_if always()
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :access_token, :string do
      allow_nil? false
      public? true
      sensitive? true
    end

    attribute :user_id, :string do
      allow_nil? false
      public? true
      sensitive? false
    end
  end
end
