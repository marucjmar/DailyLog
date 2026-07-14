defmodule Backend.Repo.Migrations.CreateIntegrationTemplates do
  use Ecto.Migration

  def change do
    create table(:integration_templates) do
      add :slug, :string
      add :name, :string
      add :description, :string
      add :input_schema, :map
      add :version, :string
      add :compiled_path, :string
      add :compiled_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:integration_templates, [:slug])
  end
end
