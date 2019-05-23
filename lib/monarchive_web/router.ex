defmodule MonarchiveWeb.Router do
  use MonarchiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MonarchiveWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/about", HomeController, :about
    get "/popular", HomeController, :popular

    get "/record/new", RecordController, :new
    get "/record/:id", RecordController, :show
    get "/record/:id/edit", RecordController, :edit

    get "/subject/new", SubjectController, :new
    get "/subject/:id", SubjectController, :show
    get "/subject/:id/edit", SubjectController, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MonarchiveWeb do
  #   pipe_through :api
  # end
end
