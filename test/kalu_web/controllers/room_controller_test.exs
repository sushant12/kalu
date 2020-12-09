defmodule KaluWeb.RoomControllerTest do
  use KaluWeb.ConnCase

  alias Kalu.Rooms

  @create_attrs %{name: "some name"}
  @update_attrs %{youtube_url: "https://www.youtube.com/watch?v=VfNqA2ukNrk"}
  @invalid_attrs %{name: nil, youtube_url: nil}

  def fixture(:room) do
    {:ok, room} = Rooms.create_room(@create_attrs)
    room
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, Routes.room_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Rooms"
    end
  end

  describe "create room" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @create_attrs)

      assert %{name: name} = redirected_params(conn)
      assert redirected_to(conn) == "/room/#{name}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      room = fixture(:room)
      conn = post(conn, Routes.room_path(conn, :create))
      assert html_response(conn, 200) =~ "New Room"
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    %{room: room}
  end
end
