defmodule AssistantWeb.Router do
  use AssistantWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AssistantWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
    # plug :accepts, ["json"]
  # end

  scope "/", AssistantWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", AssistantWeb do
    # pipe_through :api
    post "/", ApiController, :evaluate
    post "/say_hello", ApiController, :say_hello
  end

  scope "/download", AssistantWeb do

    get "/:id", DownloadController, :download
  end
end
