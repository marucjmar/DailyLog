defmodule Backend.Days.Day do
  use Ecto.Schema
  import Ecto.Changeset

  schema "days" do
    field :user_id, :binary_id
    field :date, :date
    field :events_count, :integer
    field :events_stats, :map
    field :timeline, :map
    field :summary, :string
    field :ai_summary, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(day, attrs) do
    day
    |> cast(attrs, [:user_id, :date, :events_count, :events_stats, :timeline, :summary, :ai_summary])
    |> validate_required([:user_id, :date, :events_count, :events_stats, :timeline, :summary])
  end
end
