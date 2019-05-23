defmodule MonarchiveWeb.HomeController do
  use MonarchiveWeb, :controller
  alias Monarchive.Records
  alias Monarchive.Records.Record
  alias Monarchive.Subjects
  alias Monarchive.Subjects.Subject

  def index(conn, _params) do
    records = Records.list()
    subjects = Subjects.list()

    conn
    |> assign(:records, records)
    |> assign(:subjects, subjects)
    |> assign(:title, "Depozz")
    |> render("home.html")
  end

  def about(conn, _params) do
    conn
    |> assign(:title, "About Depozz")
    |> render("about.html")
  end

  def popular(conn, _params) do
    conn
    |> assign(:title, "Popular")
    |> render("popular.html")
  end
end
