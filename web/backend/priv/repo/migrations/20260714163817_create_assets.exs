defmodule Backend.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :user_id, references(:users, on_delete: :nothing)
      add :type, :string
      add :storage_key, :string
      add :mime_type, :string
      add :size, :integer
      add :checksum, :string
      add :metadata, :map

      timestamps(type: :utc_datetime)
    end

    create index(:assets, [:user_id])
    create index(:assets, [:user_id, :type])
    create unique_index(:assets, [:user_id, :checksum])
  end
end
