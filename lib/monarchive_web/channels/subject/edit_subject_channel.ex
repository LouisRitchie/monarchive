defmodule MonarchiveWeb.EditSubjectChannel do
  use Phoenix.Channel
  alias Monarchive.Repo
  alias Monarchive.Subjects.Subject
  alias Monarchive.Subjects

  def join("edit_subject:" <> subject_id, _params, socket) do
    socket = assign(socket, :subject_id, subject_id)
    {:ok, socket}
  end

  def handle_in("submit", params, socket) do
    with %Subject{} = subject <- Repo.get(Subject, socket.assigns.subject_id) |> Repo.preload(:subject_paragraphs),
         {:ok, _} <- subject |> Subjects.update(params) do
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
