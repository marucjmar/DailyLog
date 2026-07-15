defmodule BackendWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Backend.Accounts],
    open_api: "/open_api"
end
