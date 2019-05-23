defmodule Monarchive.Repo.Migrations.AddKeysTable do
  use Ecto.Migration

  def change do
    create table(:keys, primary_key: false) do
      add :key, :string, primary_key: true
    end
  end
end
