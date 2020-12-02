defmodule KaluWeb.CommentControllerTest do
  use KaluWeb.ConnCase

  alias Kalu.Comments
  alias Kalu.Rooms

  @create_attrs %{message: "some message", name: "some name"}
  @update_attrs %{message: "some updated message", name: "some updated name"}
  @invalid_attrs %{message: nil, name: nil}

  def fixture(:room) do
    {:ok, room} = Rooms.create_room(%{name: "test-room"})
    room
  end

  def fixture(:comment) do
    {:ok, comment} = Comments.create_comment(@create_attrs)
    comment
  end

  describe "index" do
    test "lists all comments", %{conn: conn} do
      conn = get(conn, Routes.comment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Comments"
    end
  end

  describe "create comment" do
    test "redirects to show when data is valid", %{conn: conn} do
      room = fixture(:room)

      conn =
        post(conn, Routes.comment_path(conn, :create),
          comment: @create_attrs |> Enum.into(%{room_id: room.id})
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.comment_path(conn, :show, id)

      conn = get(conn, Routes.comment_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Comment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.comment_path(conn, :create), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Comment"
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
    %{comment: comment}
  end
end
