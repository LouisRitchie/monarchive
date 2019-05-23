defmodule MonarchiveWeb.RecordController do
  use MonarchiveWeb, :controller
  alias Monarchive.Records
  alias Monarchive.Records.Record

  def new(conn, _params) do
    {:ok, %Record{id: id}} = Records.create()

    conn
    |> redirect(to: "/record/#{id}/edit")
  end

  def show(conn, %{"id" => id}) do
    %{name: name, description: description, record_paragraphs: record_paragraphs, header_asset: header_asset} = Records.get(id)

    IO.inspect header_asset

    conn
    |> assign(:id, id)
    |> assign(:name, name)
    |> assign(:title, name)
    |> assign(:header_asset, header_asset)
    |> assign(:description, description)
    |> assign(:paragraphs, record_paragraphs)
    |> render("record.html")
  end

  def edit(conn, %{"id" => id}) do
    %{id: id, name: name, description: description, record_paragraphs: record_paragraphs, header_asset: header_asset, other_assets: other_assets} = Records.get(id)

    conn
    |> assign(:id, id)
    |> assign(:name, name)
    |> assign(:title, "Edit Record #{name}")
    |> assign(:description, description)
    |> assign(:paragraphs, record_paragraphs)
    |> assign(:header_asset, header_asset)
    |> assign(:other_assets, other_assets)
    |> render("edit_record.html")
  end
end
