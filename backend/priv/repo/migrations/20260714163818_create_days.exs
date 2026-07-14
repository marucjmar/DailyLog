defmodule Backend.Repo.Migrations.CreateDays do
  use Ecto.Migration

  def change do
    create table(:days) do
      add :user_id, references(:users, on_delete: :nothing)
      add :date, :date
      add :events_count, :integer
      add :events_stats, :map
      add :timeline, :map
      add :summary, :text

      timestamps(type: :utc_datetime)
    end

    create index(:days, [:user_id, :date])
    create index(:days, [:date])
  end
end
