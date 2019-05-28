defmodule Monarchive.Assets do
  alias Monarchive.Repo
  alias Monarchive.Assets.Asset

  @asset_dir "priv/static/images/content"

  def create(%{filename: filename, raw_bytes: bytelist}) do
    asset = Repo.insert! %Asset{filename: filename}

    uri = "#{asset.id}" <> "___" <> filename
    store_original_asset(bytelist, uri)
    create_and_store_asset_thumbnail(uri)

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

  defp store_original_asset(bytelist, uri) do
    bytes = get_binary_from_bytelist(bytelist)
    File.write!(@asset_dir <> "/originals/" <> uri, bytes)
  end

  defp create_and_store_asset_thumbnail(uri) do
    @asset_dir <> "/originals/" <> uri
    |> Mogrify.open
    |> Mogrify.resize("100x100")
    |> Mogrify.save(path: @asset_dir <> "/thumbnails/" <> uri)
  end

  defp get_binary_from_bytelist(bytelist) do
    length = map_size(bytelist)
    bytes = Enum.map(1..length, fn i -> bytelist["#{i - 1}"] end)
    :binary.list_to_bin(bytes) <> <<0>>
  end
end
