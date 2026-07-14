defmodule Backend.Accounts do
  use Ash.Domain, otp_app: :backend, extensions: [AshJsonApi.Domain, AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Backend.Accounts.Token
    resource Backend.Accounts.User
  end
end
