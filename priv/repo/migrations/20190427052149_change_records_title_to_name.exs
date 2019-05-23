defmodule Monarchive.Repo.Migrations.ChangeRecordsTitleToName do
  use Ecto.Migration

  def change do
    rename table(:records), :title, to: :name
  end
end
