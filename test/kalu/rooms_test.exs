defmodule Kalu.RoomsTest do
  use Kalu.DataCase

  alias Kalu.Rooms

  describe "rooms" do
    alias Kalu.Rooms.Room

    @valid_attrs %{
      name: Faker.Team.creature()
    }
    @update_attrs %{
      name: Faker.Team.creature(),
      youtube_video_id: "https://www.youtube.com/watch?v=G7RgN9ijwE4"
    }
    @invalid_attrs %{name: nil, youtube_url: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()

      {:ok, room} =
        Rooms.update_room(room, %{youtube_video_id: "https://www.youtube.com/watch?v=G7RgN9ijwE4"})

      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "get_room!/1 returns an exception if the room id is not given" do
      assert_raise(Ecto.NoResultsError, fn -> Rooms.get_room!(1) end)
    end

    test "get_room_by_name!/1 returns the room with given name" do
      room = room_fixture()
      assert Rooms.get_room_by_name!(room.name) == room
    end

    test "get_room_by_name!/1 returns an exception if  the room with given name is not found" do
      assert_raise(Ecto.NoResultsError, fn -> Rooms.get_room_by_name!("fail") end)
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@valid_attrs)
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Rooms.update_room(room, @update_attrs)
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
