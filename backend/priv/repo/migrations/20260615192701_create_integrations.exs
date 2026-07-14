defmodule Backend.Repo.Migrations.CreateIntegrations do
  use Ecto.Migration

  def change do
    create table(:integrations) do
      add :source_code, :text
      add :source_code_dependencies, :map
      add :compiled_path, :string
      add :inputs, :map
      add :status, :string
      add :last_error, :text
      add :last_synced_at, :utc_datetime
      add :next_sync_at, :utc_datetime
      add :enabled, :boolean
      add :sync_interval_minutes, :integer

      add :user_id, references(:users, on_delete: :nothing)
      add :template_id, references(:integration_templates, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:integrations, [:user_id])
    create index(:integrations, [:template_id])

    create constraint(:integrations, :source_xor_template, check: "(template_id IS NULL) != (source_code IS NULL)")
    create index(:integrations, [:status])
    create index(:integrations, [:user_id, :status])
    create index(:integrations, [:user_id, :template_id])
  end
end
