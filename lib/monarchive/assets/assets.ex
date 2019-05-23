defmodule Monarchive.Assets do
  alias Monarchive.Repo
  alias Monarchive.Assets.Asset

  def create(%{filename: filename, raw_bytes: raw_bytes}) do
    asset = %Asset{filename: filename} |> Repo.insert!

    filepath = "/images/content/fullsize/#{asset.id}___#{filename}"
    full_filepath = "priv/static#{filepath}"

    length = map_size(raw_bytes)
    bytes = Enum.map(1..length, fn i -> raw_bytes["#{i - 1}"] end)
    bytes = :binary.list_to_bin(bytes) <> <<0>>
    File.write!(full_filepath, bytes)

    {:ok, asset} = update(asset, %{filepath: filepath})

    asset
  end

  def update(%Asset{id: id} = asset, params) do
    asset
    |> Asset.changeset(params)
    |> Repo.update!

    {:ok, Repo.get(Asset, id)}
  end

  def delete(%Asset{} = asset) do
    Repo.delete! asset
    File.rm! "priv/static#{asset.filepath}"
  end
end
