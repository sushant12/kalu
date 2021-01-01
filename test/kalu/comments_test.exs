defmodule Kalu.CommentsTest do
  use Kalu.DataCase

  alias Kalu.Comments
  alias Kalu.Rooms

  describe "comments" do
    alias Kalu.Comments.Comment

    @valid_attrs %{message: Faker.String.naughty(), name: Faker.Person.name()}
    @invalid_attrs %{message: nil, name: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Rooms.create_room()

      room
    end

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Comments.create_comment()

      comment
    end

    test "list_comments/1 returns last 10 comments of a room" do
      room = room_fixture(%{name: "test-room"})

      Enum.each(1..20, fn _ ->
        comment_fixture(%{room_id: room.id})
      end)

      assert Comments.list_comments(room.id) |> Enum.count() == 10
    end

    test "create_comment/1 with valid data creates a comment" do
      room = room_fixture(%{name: "test-room"})

      assert {:ok, %Comment{} = comment} =
               Comments.create_comment(%{
                 name: "username",
                 message: "test message",
                 room_id: room.id
               })

      assert comment.message == "test message"
      assert comment.name == "username"
      assert comment.room_id == room.id
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "change_comment/1 returns a comment changeset" do
      room = room_fixture(%{name: "test-room"})
      comment = comment_fixture(%{room_id: room.id})
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
