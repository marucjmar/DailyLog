defmodule Backend.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Backend.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:backend, :token_signing_secret)
  end
end
