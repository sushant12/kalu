defmodule KaluWeb.RoomLive do
  use KaluWeb, :live_view
  alias Kalu.Rooms
  alias Kalu.Comments

  alias KaluWeb.Presence

  @impl true
  def mount(%{"name" => name}, _session, socket) do
    room = Rooms.get_room_by_name!(name)
    KaluWeb.Endpoint.subscribe("room:#{room.name}")

    {:ok,
     assign(socket,
       room: room,
       changeset: Rooms.change_room(room),
       username: Faker.Person.name(),
       messages: Comments.list_comments(room.id) |> Enum.reverse(),
       message: Comments.change_comment(%Kalu.Comments.Comment{})
     )}
  end

  @impl true
  def handle_event("save", %{"room" => %{"youtube_url" => youtube_url}}, socket) do
    case socket.assigns.params["name"]
         |> Rooms.get_room_by_name!()
         |> Rooms.update_room(%{"youtube_video_id" => youtube_url}) do
      {:ok, room} ->
        KaluWeb.Endpoint.broadcast_from(self(), "room:#{room.name}", "video_saved", %{room: room})
        {:noreply, assign(socket, :room, room)}

      {:error, _changeset} ->
        {:noreply, socket |> put_flash(:error, "something went wrong")}
    end
  end

  @impl true
  def handle_event("play_video", _params, socket) do
    room_name = socket.assigns.params["name"]

    KaluWeb.Endpoint.broadcast_from(self(), "room:#{room_name}", "video_played", %{
      room_name: room_name
    })

    {:noreply, assign(socket, :room_name, room_name)}
  end

  @impl true
  def handle_event("pause_video", _params, socket) do
    room_name = socket.assigns.params["name"]

    KaluWeb.Endpoint.broadcast_from(self(), "room:#{room_name}", "video_paused", %{
      room_name: room_name
    })

    {:noreply, assign(socket, :room_name, room_name)}
  end

  @impl true
  def handle_info(%{event: "video_played"}, socket) do
    {:noreply, push_event(socket, "video_played", %{})}
  end

  @impl true
  def handle_info(%{event: "video_paused"}, socket) do
    {:noreply, push_event(socket, "video_paused", %{})}
  end

  @impl true
  def handle_info(%{event: "video_saved", payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  @impl true
  def handle_info(%{event: "message_sent", payload: state}, socket) do
    send_update(KaluWeb.MessageComponent,
      id: socket.assigns.room.id,
      message: Comments.change_comment(%Kalu.Comments.Comment{}),
      messages: Comments.list_comments(socket.assigns.room.id) |> Enum.reverse()
    )

    {:noreply, assign(socket, state)}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    room_name = socket.assigns.params["name"]

    users =
      Presence.list("room:#{room_name}")
      |> Enum.map(fn {_topic, connected_users} ->
        connected_users[:metas]
      end)
      |> List.flatten()

    send_update(KaluWeb.OnlineUsersComponent,
      id: socket.assigns.room.id,
      room: socket.assigns.room,
      username: socket.assigns.username
    )

    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, :params, params)}
  end
end
