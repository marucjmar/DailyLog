defmodule Backend.Repo.Migrations.CreateAccountUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
