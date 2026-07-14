defmodule Backend.Repo.Migrations.CreateSyncLogs do
  use Ecto.Migration

  def change do
    create table(:sync_logs) do
      add :status, :string
      add :duration_ms, :integer
      add :events_count, :integer
      add :error, :text
      add :integration_id, references(:integrations, on_delete: :nothing)

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:sync_logs, [:integration_id])
    create index(:sync_logs, [:integration_id, :inserted_at])
  end
end
