defmodule Monarchive.Repo.Migrations.CreateAssetsTableAndNewRelationships do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :filename, :string
      add :filepath, :string
      add :description, :string
      add :date_recorded, :date

      add :record_id, :string
      add :record_paragraph_id, :bigint
      add :subject_id, :string
      add :subject_paragraph_id, :bigint

      timestamps()
    end
  end
end
