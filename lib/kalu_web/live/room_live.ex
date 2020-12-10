defmodule KaluWeb.RoomLive do
  use KaluWeb, :live_view
  alias Kalu.Rooms

  @impl true
  def mount(%{"name" => name}, _session, socket) do
    room = Rooms.get_room_by_name!(name)
    {:ok, assign(socket, room: room, changeset: Rooms.change_room(room))}
  end

  @impl true
  def handle_event("save", %{"room" => %{"youtube_url" => youtube_url}}, socket) do
    case socket.assigns.params["name"]
         |> Rooms.get_room_by_name!()
         |> Rooms.update_room(%{"youtube_video_id" => youtube_url}) do
      {:ok, room} ->
        {:noreply, assign(socket, :room, room)}

      {:error, _changeset} ->
        {:noreply, socket |> put_flash(:error, "something went wrong")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, :params, params)}
  end
end
