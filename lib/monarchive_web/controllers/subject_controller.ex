defmodule MonarchiveWeb.SubjectController do
  use MonarchiveWeb, :controller
  alias Monarchive.Subjects
  alias Monarchive.Subjects.Subject

  def new(conn, _params) do
    {:ok, %Subject{id: id}} = Subjects.create()

    conn
    |> redirect(to: "/subject/#{id}/edit")
  end

  def show(conn, %{"id" => id}) do
    %{id: id, name: name, description: description, subject_paragraphs: subject_paragraphs, header_asset: header_asset} = Subjects.get(id)

    conn
    |> render("subject.html", name: name, description: description, paragraphs: subject_paragraphs, id: id, title: name, header_asset: header_asset)
  end

  def edit(conn, %{"id" => id}) do
    %{id: id, name: name, description: description, subject_paragraphs: subject_paragraphs, header_asset: header_asset, other_assets: other_assets} = Subjects.get(id)

    conn
    |> render("edit_subject.html", name: name, description: description, paragraphs: subject_paragraphs, id: id, title: "Edit Subject #{name}", header_asset: header_asset, other_assets: other_assets)
  end
end
