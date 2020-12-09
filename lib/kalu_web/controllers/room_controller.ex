defmodule KaluWeb.RoomController do
  use KaluWeb, :controller

  alias Kalu.Rooms

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def create(conn, _params) do
    case Rooms.create_room(%{name: random_string()}) do
      {:ok, room} ->
        conn
        |> redirect(to: Routes.room_path(conn, :show, room.name))

      {:error, _} ->
        rooms = Rooms.list_rooms()
        render(conn, "index.html", rooms: rooms)
    end
  end

  def show(conn, %{"name" => name}) do
    room = Rooms.get_room_by_name!(name)
    changeset = Rooms.change_room(room)
    render(conn, "show.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Rooms.get_room!(id)

    case Rooms.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  defp random_string() do
    :crypto.strong_rand_bytes(5) |> Base.url_encode64()
  end
end
