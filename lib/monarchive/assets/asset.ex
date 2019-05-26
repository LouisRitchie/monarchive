defmodule Monarchive.Assets.Asset do
  @moduledoc """
  The Asset schema represents an image, gif, or video.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Monarchive.Records.Record
  alias Monarchive.Records.RecordParagraph
  alias Monarchive.Subjects.Subject
  alias Monarchive.Subjects.SubjectParagraph

  schema "assets" do
    field :filename, :string
    field :uri, :string

    belongs_to(:record, Record, type: :string)
    belongs_to(:subject, Subject, type: :string)
    belongs_to(:record_paragraph, RecordParagraph)
    belongs_to(:subject_paragraph, SubjectParagraph)

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:filename, :uri, :record_id, :subject_id, :record_paragraph_id, :subject_paragraph_id])
    |> cast_assoc(:record)
    |> cast_assoc(:record_paragraph)
    |> cast_assoc(:subject)
    |> cast_assoc(:subject_paragraph)
    |> validate_required([:filename])
  end
end
