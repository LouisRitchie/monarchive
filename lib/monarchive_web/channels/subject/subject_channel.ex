defmodule MonarchiveWeb.SubjectChannel do
  use Phoenix.Channel
  alias Monarchive.Subjects

  def join("subject:" <> subject_id, _params, socket) do
    socket = assign(socket, :subject_id, subject_id)
    {:ok, socket}
  end

  def handle_in("checkout", _params, socket) do
    with {:ok, subject} <- Subjects.checkout(socket.assigns[:subject_id]) do
      {:ok, subject, socket}
    else
      {:error, error} ->
        {:error, error, socket}
    end
  end

  def handle_in("checkin", _params, socket) do
    with {:ok, subject} <- Subjects.checkin(socket.assigns[:subject_id]) do
      {:ok, subject, socket}
    else
      {:error, error} ->
        {:error, error, socket}
    end
  end

  def handle_in("delete", _params, socket) do
    with {:ok, subject} <- Subjects.delete(socket.assigns[:subject_id]) do
      {:ok, subject, socket}
    else
      {:error, error} ->
        {:error, error, socket}
    end
  end

  def terminate(_params, _socket) do
    {:ok, nil}
  end
end
