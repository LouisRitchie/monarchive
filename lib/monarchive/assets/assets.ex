defmodule Monarchive.Assets do
  alias Monarchive.Repo
  alias Monarchive.Assets.Asset

  @asset_dir "priv/static/assets/content"

  def create(%{filename: filename, raw_bytes: bytelist}) do
    asset = %Asset{filename: filename} |> Repo.insert!

    uri = asset.id <> "___" <> filename
    original_uri = "/original/" <> uri
    thumbnail_uri = "/thumbnails/" <> uri

    bytes = get_binary_from_bytelist(bytelist)
    Mogrify.open(@asset_dir <> original_uri) |> Mogrify.resize("100x100") |> Mogrify.save(path: @asset_dir <> thumbnail_uri)

    {:ok, asset} = update(asset, %{uri: uri})

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

  defp get_binary_from_bytelist(bytelist) do
    length = map_size(bytelist)
    bytes = Enum.map(1..length, fn i -> bytelist["#{i - 1}"] end)
    :binary.list_to_bin(bytes) <> <<0>>
  end

  defp store_original_asset(bytes) do
    File.write!(@asset_dir <> original_uri, bytes)
  end

  #defp store_thumbnail()
end
