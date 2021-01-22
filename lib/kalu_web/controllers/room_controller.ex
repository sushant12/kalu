defmodule KaluWeb.RoomController do
  use KaluWeb, :controller
  alias Kalu.Rooms

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def create(conn, _params) do
    case Rooms.create_room(%{name: Faker.Team.name()}) do
      {:ok, room} ->
        conn
        |> redirect(to: Routes.live_path(conn, KaluWeb.RoomLive, room.name))

      {:error, _} ->
        rooms = Rooms.list_rooms()
        render(conn, "index.html", rooms: rooms)
    end
  end
end
