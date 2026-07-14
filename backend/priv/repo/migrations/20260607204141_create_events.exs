defmodule Backend.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :user_id, references(:users, on_delete: :nothing)
      add :type, :string
      add :source, :string
      add :timestamp, :utc_datetime
      add :payload, :map
      add :unique_hash, :string

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:user_id, :timestamp])
    create index(:events, [:user_id, :type])
    create index(:events, [:timestamp])
    create index(:events, [:unique_hash])

    create unique_index(:events, [:user_id, :unique_hash])
  end
end
