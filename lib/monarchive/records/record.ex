defmodule Monarchive.Records.Record do
  @moduledoc """
  The Record schema represents a record of something.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Monarchive.Assets.Asset
  alias Monarchive.Records.{RecordParagraph, RecordRelationship}
  
  @primary_key {:id, :string, autogenerate: {Monarchive.Keys.KeyGenerator, :generate_key, []}}

  schema "records" do
    field :name, :string
    field :description, :string

    has_many(:record_paragraphs, RecordParagraph)
    has_one(:header_asset, Asset)
    has_many(:other_assets, Asset)

    has_many(:record_relationships, RecordRelationship)
    has_many(:subjects, through: [:record_relationships, :subject])

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
