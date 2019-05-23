defmodule MonarchiveWeb.RecordChannel do
  use Phoenix.Channel
  alias Monarchive.Records.Record
  alias Monarchive.Repo

  def join("record:" <> record_id, _params, socket) do
    socket = assign(socket, :record_id, record_id)
    {:ok, socket}
  end

  def handle_in("delete", _params, socket) do
    Record
    |> Repo.get(socket.assigns.record_id)
    |> Repo.delete

    {:ok, socket}
  end

  def terminate(_params, _socket) do
    {:ok, nil}
  end
end
