defmodule Monarchive.Subjects.Subject do
  @moduledoc """
  The Subject schema represents a subject, like a proper noun or category
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Monarchive.Assets.Asset
  alias Monarchive.Records.{Record, RecordRelationship}
  alias Monarchive.Subjects.SubjectParagraph
  
  @primary_key {:id, :string, autogenerate: {Monarchive.Keys.KeyGenerator, :generate_key, []}}

  schema "subjects" do
    field :name, :string
    field :description, :string

    has_many(:subject_paragraphs, SubjectParagraph)
    has_one(:header_asset, Asset)
    has_many(:other_assets, Asset)

    has_many(:record_relationships, RecordRelationship)
    has_many(:records, through: [:record_relationships, :record])

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
