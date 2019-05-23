defmodule Monarchive.Repo.Migrations.AddOrderToSubjectAndRecordParagraphs do
  use Ecto.Migration

  def change do
    alter table(:subject_paragraphs) do
      add :order, :integer
    end

    alter table(:record_paragraphs) do
      add :order, :integer
    end
  end
end
