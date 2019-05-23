defmodule Monarchive.Repo.Migrations.RecordSubjectRelationship do
  use Ecto.Migration

  def change do
    create table(:record_relationships) do
      add :record_id, references(:records, type: :string), null: false
      add :subject_id, references(:subjects, type: :string), null: false
      timestamps()
    end

    create index(:record_relationships, [:record_id])
    create index(:record_relationships, [:subject_id])

    create unique_index(:record_relationships, [:record_id, :subject_id], name: :unique_record_subject_relationship)
  end
end
