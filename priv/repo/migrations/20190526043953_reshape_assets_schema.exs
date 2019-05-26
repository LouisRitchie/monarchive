defmodule Monarchive.Repo.Migrations.ReshapeAssetsSchema do
  use Ecto.Migration

  def change do
    alter table(:assets) do
      remove :filepath
      remove :description
      remove :date_recorded
      add :uri, :string
    end
  end
end
