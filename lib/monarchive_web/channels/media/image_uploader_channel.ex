defmodule MonarchiveWeb.ImageUploaderChannel do
  use Phoenix.Channel
  alias Monarchive.Assets

  def join("image_uploader:" <> entity_id, _params, socket) do
    # entity_id is the record or subject to which the images will be attached
    socket = assign(socket, :entity_id, entity_id)
    {:ok, socket}
  end

  def handle_in("upload", %{"raw_bytes" => raw_bytes, "filename" => filename}, socket) do
    %{filename: filename, filepath: filepath} = Assets.create(%{filename: filename, raw_bytes: raw_bytes})

    {:reply, {:ok, %{filename: filename, filepath: filepath}}, socket}
  end

  def terminate(_params, _socket) do
    {:ok, nil}
  end
end
