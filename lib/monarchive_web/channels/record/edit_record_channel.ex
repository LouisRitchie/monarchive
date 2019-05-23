defmodule MonarchiveWeb.EditRecordChannel do
  use Phoenix.Channel
  alias Monarchive.Repo
  alias Monarchive.Records.Record
  alias Monarchive.Records

  def join("edit_record:" <> record_id, _params, socket) do
    socket = assign(socket, :record_id, record_id)
    {:ok, socket}
  end

  def handle_in("submit", params, socket) do
    IO.inspect params

    with %Record{} = record <- Repo.get(Record, socket.assigns.record_id) |> Repo.preload(:record_paragraphs),
         {:ok, _} <- record |> Records.update(params) do
      {:reply, {:ok, %{}}, socket}
    else
      {:error, _error} = error ->
        {:reply, error, socket}
    end
  end

  def terminate(_params, _socket) do
    {:ok, nil}
  end
end
