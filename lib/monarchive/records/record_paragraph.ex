defmodule Monarchive.Records.RecordParagraph do
  @moduledoc """
  The RecordParagraph schema represents content for a record.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Monarchive.Records.Record
  alias Monarchive.Assets.Asset

  schema "record_paragraphs" do
    field :header, :string
    field :content, :string
    field :order, :integer

    belongs_to(:record, Record, type: :string)
    has_one(:asset, Asset)

    timestamps()
  end

  @doc false
  def changeset(record_paragraph, attrs) do
    record_paragraph
    |> cast(attrs, [:header, :content, :record_id, :order])
    |> cast_assoc(:record)
    |> validate_required([:content, :record_id])
  end
end
