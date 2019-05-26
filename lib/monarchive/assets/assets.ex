defmodule Monarchive.Assets do
  alias Monarchive.Repo
  alias Monarchive.Assets.Asset

  @internal_img_dir "priv/static/images/content"

  def create(%{filename: filename, raw_bytes: bytelist}) do
    asset = %Asset{filename: filename} |> Repo.insert!

    uri = asset.id <> "___" <> filename
    fullsize_uri = "/fullsize/" <> uri
    thumbnail_uri = "/thumbnails/" <> uri

    bytes = get_binary_from_bytelist(bytelist)
    File.write!(@internal_img_dir <> fullsize_uri, bytes)
    Mogrify.open(@internal_img_dir <> fullsize_uri) |> Mogrify.resize("100x100") |> Mogrify.save(path: @internal_img_dir <> thumbnail_uri)

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
end
