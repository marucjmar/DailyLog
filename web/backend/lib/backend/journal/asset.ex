defmodule Backend.Journal.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assets" do
    field :user_id, :binary_id
    field :type, :string
    field :storage_key, :string
    field :mime_type, :string
    field :size, :integer
    field :checksum, :string
    field :metadata, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:user_id, :type, :storage_key, :mime_type, :size, :checksum, :metadata])
    |> validate_required([:user_id, :type, :storage_key, :mime_type, :size, :checksum])
  end
end
