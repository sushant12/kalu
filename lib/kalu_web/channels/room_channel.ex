defmodule KaluWeb.RoomChannel do
  use Phoenix.Channel
  alias Kalu.Rooms

  def join("room:" <> room_name, _message, socket) do
    Rooms.get_room_by_name!(room_name)
    {:ok, socket}
  end
end
