defmodule Monarchive.Keys.Key do
  use Ecto.Schema
  
  @primary_key {:key, :string, autogenerate: false}

  schema "keys" do
  end
end
