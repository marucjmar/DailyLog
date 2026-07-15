defmodule Backend.Journal.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @event_types [
    "photo",
    "activity",
    "task",
    "note"
  ]

  schema "events" do
    field :user_id, :integer
    field :type, :string
    field :source, :string
    field :timestamp, :utc_datetime
    field :payload, :map
    field :unique_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :source, :timestamp, :payload, :unique_hash, :user_id])
    |> validate_required([:type, :source, :timestamp, :unique_hash, :user_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:unique_hash)
    |> validate_inclusion(:type, @event_types)
    |> cast_payload_by_type(attrs)
  end

  defp cast_payload_by_type(changeset, attrs) do
    type = get_field(changeset, :type)

    module =
      case type do
        :photo -> Backend.Journal.Payloads.Photo
        :activity -> Backend.Journal.Payloads.Activity
        :task -> Backend.Journal.Payloads.Task
        :note -> Backend.Journal.Payloads.Note
        _ -> nil
      end

    if module do
      payload_changeset = module.changeset(module, Map.get(attrs, "payload", %{}))

      if payload_changeset.valid? do
        put_change(changeset, :payload, Ecto.Changeset.apply_changes(payload_changeset))
      else
        add_error(changeset, :payload, "invalid payload")
      end
    else
      changeset
    end
  end
end

defmodule Backend.Journal.Payloads.Photo do
  use Ecto.Schema

  embedded_schema do
    field :asset_id, :binary_id
    field :lat, :float
    field :lng, :float
  end

  def changeset(struct, attrs) do
    struct
    |> Ecto.Changeset.cast(attrs, [:asset_id, :lat, :lng])
    |> Ecto.Changeset.validate_required([:asset_id])
  end
end

defmodule Backend.Journal.Payloads.Activity do
  use Ecto.Schema

  embedded_schema do
    field :distance, :integer
    field :duration, :integer
    field :sport, :string
    field :asset_id, :binary_id
  end

  def changeset(struct, attrs) do
    struct
    |> Ecto.Changeset.cast(attrs, [:distance, :duration, :sport, :asset_id])
    |> Ecto.Changeset.validate_required([:distance, :duration, :sport, :asset_id])
  end
end

defmodule Backend.Journal.Payloads.Note do
  use Ecto.Schema

  embedded_schema do
    field :note, :string
  end

  def changeset(struct, attrs) do
    struct
    |> Ecto.Changeset.cast(attrs, [:note])
    |> Ecto.Changeset.validate_required([:note])
  end
end

defmodule Backend.Journal.Payloads.Task do
  use Ecto.Schema

  embedded_schema do
    field :task, :string
    field :description, :string
    field :completed, :boolean, default: false
  end

  def changeset(struct, attrs) do
    struct
    |> Ecto.Changeset.cast(attrs, [:task, :description, :completed])
    |> Ecto.Changeset.validate_required([:task, :description])
  end
end
