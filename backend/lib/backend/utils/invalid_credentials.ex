defmodule Backend.Accounts.Errors.InvalidCredentials do
  use Splode.Error,
    fields: [],
    class: :invalid

  def message(_error) do
    "Invalid email or password"
  end
end
