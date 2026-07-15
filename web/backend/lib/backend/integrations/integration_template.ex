defmodule Backend.Integrations.IntegrationTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Integrations.Integration

  schema "integration_templates" do
    # "garmin", "immich"
    field :slug, :string
    field :name, :string
    field :description, :string
    # zdenormalizowany manifest.inputs
    field :input_schema, :map
    field :version, :string
    # nil dopóki nikt nie użył
    field :compiled_path, :string
    field :compiled_at, :utc_datetime

    has_many :integrations, Integration
    timestamps()
  end

  def changeset(template, attrs) do
    template
    |> cast(attrs, [:slug, :name, :description, :input_schema, :version])
    |> validate_required([:slug, :name, :input_schema])
    |> unique_constraint(:slug)
  end
end
