defmodule KaluWeb.Router do
  use KaluWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {KaluWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KaluWeb do
    pipe_through :browser

    get "/", RoomController, :index
    live "/room/:name", RoomLive
    resources "/room", RoomController, only: [:create]
    resources "/comment", CommentController, only: [:create, :index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", KaluWeb do
  #   pipe_through :api
  # end
end
