defmodule Monarchive.Repo.Migrations.AddRecordsAndSubjects do
  use Ecto.Migration

  def change do
    create table(:subjects, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :description, :string
      add :image_url, :string
      timestamps()
    end

    create table(:subject_paragraphs) do
      add :header, :string
      add :content, :string, size: 2056
      add :image_url, :string
      add :subject_id, references(:subjects, type: :string, on_delete: :delete_all), null: false
      timestamps()
    end

    create table(:records, primary_key: false) do
      add :id, :string, primary_key: true
      add :title, :string
      add :description, :string
      add :image_url, :string
      timestamps()
    end

    create table(:record_paragraphs) do
      add :header, :string
      add :content, :string, size: 2056
      add :image_url, :string
      add :record_id, references(:records, type: :string, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:record_paragraphs, [:record_id])

    create index(:subject_paragraphs, [:subject_id])
  end
end
