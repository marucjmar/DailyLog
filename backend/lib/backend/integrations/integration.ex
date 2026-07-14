defmodule Backend.Integrations.Integration do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Integrations.IntegrationTemplate
  alias Backend.Integrations.SyncLog

  schema "integrations" do
    belongs_to :user, Accounts.User
    # nil dla custom
    belongs_to :template, IntegrationTemplate

    # nil dla builtin
    field :source_code, :string
    # nil dla builtin
    field :source_code_dependencies, :map
    # nil dopóki pending
    field :compiled_path, :string
    # zaszyfrowane — Cloak.Ecto.Map
    field :inputs, :map

    field :status, Ecto.Enum,
      values: [:pending, :compiling, :ready, :error, :paused],
      default: :pending

    field :last_error, :string
    field :next_sync_at, :utc_datetime
    field :last_synced_at, :utc_datetime
    field :enabled, :boolean
    field :sync_interval_minutes, :integer

    has_many :sync_logs, SyncLog
    timestamps()
  end

  @doc false
  def changeset(conn, attrs) do
    conn
    |> cast(attrs, [
      :template_id,
      :source_code,
      :inputs,
      :source_code_dependencies,
      :sync_interval_minutes,
      :enabled,
      :last_synced_at,
      :next_sync_at,
      :compiled_path
    ])
    |> validate_required([:inputs])
    |> validate_source_xor_template()
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:template_id)
  end

  defp validate_source_xor_template(cs) do
    case {get_field(cs, :template_id), get_field(cs, :source_code)} do
      {nil, nil} ->
        add_error(cs, :base, "template_id or source_code is required")

      {t, s} when not is_nil(t) and not is_nil(s) ->
        add_error(cs, :base, "cannot set both template_id and source_code")

      _ ->
        cs
    end
  end
end
