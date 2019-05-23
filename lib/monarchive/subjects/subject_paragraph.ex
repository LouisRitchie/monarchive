defmodule Monarchive.Subjects.SubjectParagraph do
  @moduledoc """
  The SubjectParagraph schema represents content describing a subject.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Monarchive.Subjects.Subject
  alias Monarchive.Assets.Asset

  schema "subject_paragraphs" do
    field :header, :string
    field :content, :string
    field :order, :integer

    belongs_to(:subject, Subject, type: :string)
    has_one(:asset, Asset)

    timestamps()
  end

  @doc false
  def changeset(subject_paragraph, attrs) do
    subject_paragraph
    |> cast(attrs, [:header, :content, :subject_id, :order])
    |> cast_assoc(:subject)
    |> validate_required([:content, :subject_id])
  end
end
