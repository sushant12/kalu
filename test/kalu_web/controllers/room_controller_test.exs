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

  describe "update room" do
    setup [:create_room]

    test "redirects when data is valid", %{conn: conn, room: room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @update_attrs)
      assert redirected_to(conn) == Routes.room_path(conn, :show, room)

      conn = get(conn, Routes.room_path(conn, :show, room))
      assert html_response(conn, 200) =~ "https://www.youtube.com/watch?v=VfNqA2ukNrk"
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Room"
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    %{room: room}
  end
end
