defmodule KaluWeb.RoomLiveTest do
  use KaluWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Kalu.Rooms

  describe "room_live" do
    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Rooms.create_room()

      room
    end

    test "saves youtube url", %{conn: conn} do
      room_fixture(%{name: "test"})

      {:ok, view, _html} = live(conn, "/room/test")

      view
      |> form("#url-form", room: %{youtube_url: "https://www.youtube.com/watch?v=ROd2JuDM8lc"})
      |> render_submit()

      assert Rooms.list_rooms() |> Enum.count() == 1
    end

    test "fails to save youtube url", %{conn: conn} do
      room_fixture(%{name: "test"})

      {:ok, view, _html} = live(conn, "/room/test")

      view
      |> form("#url-form", room: %{youtube_url: "xyz"})
      |> render_submit()

      assert [] = Rooms.list_rooms()
    end

    test "show connected users", %{conn: conn} do
      room_fixture(%{name: "test"})
      {:ok, _view, html_string} = live(conn, "/room/test")

      assert html_string
             |> Floki.parse_document!()
             |> Floki.find("#online-users li")
             |> Enum.count() > 0
    end

    test "send message in the room", %{conn: conn} do
      room = room_fixture(%{name: "test"})
      {:ok, view, html_string} = live(conn, "/room/test")

      html =
        view
        |> form("#chat-form", comment: %{message: "hello world"})
        |> render_submit(%{
          name:
            html_string
            |> Floki.parse_document!()
            |> Floki.find("#online-users li")
            |> hd()
            |> Floki.text(),
          room_id: room.id
        })

      assert true =
               html
               |> Floki.parse_fragment!()
               |> Floki.find(".chat-content .message")
               |> Floki.text()
               |> String.contains?("hello world")
    end
  end
end
