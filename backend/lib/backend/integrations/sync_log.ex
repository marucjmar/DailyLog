defmodule Backend.Integrations.SyncLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sync_logs" do
    belongs_to :integration, Connection

    field :status,       Ecto.Enum, values: [:ok, :error, :timeout]
    field :duration_ms,  :integer
    field :events_count, :integer
    field :error,        :string     # skrócony output jeśli failed

    timestamps(updated_at: false)    # insert only — logi nie są edytowane
  end

  @doc false
  def changeset(sync_log, attrs) do
    sync_log
    |> cast(attrs, [:status, :duration_ms, :events_count, :error])
    |> validate_required([:status, :duration_ms, :events_count])
  end
end
