defmodule Monarchive.Records.RecordRelationship do
  use Ecto.Schema
  import Ecto.Changeset
  alias Monarchive.Records.Record
  alias Monarchive.Subjects.Subject

  schema "record_relationships" do
    belongs_to(:record, Record)
    belongs_to(:subject, Subject)
    timestamps()
  end

  def changeset(record_relationship, attrs) do
    record_relationship
    |> cast(attrs, [:record_id, :subject_id])
    |> validate_required([:record_id, :subject_id])
    |> unique_constraint(
      :unique_record_subject_relationship,
      name: :unique_record_subject_relationship
    )
  end
end
