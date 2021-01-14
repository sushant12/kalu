defmodule KaluWeb.OnlineUsersComponent do
  use KaluWeb, :live_component
  alias KaluWeb.Presence

  @impl true
  def render(assigns) do
    ~L"""
    <div class="column">
      <h3>Online</h3>
      <ul>
      <%= for user <- @users do %>
        <li><%= user.name %> </li>
      <% end %>
      </ul>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    username = :crypto.strong_rand_bytes(5) |> Base.url_encode64()

    Presence.track(self(), "room:#{assigns.room.name}", assigns.room.name, %{
      name: username
    })

    users =
      Presence.list("room:#{assigns.room.name}")
      |> Enum.map(fn {_topic, connected_users} ->
        connected_users[:metas]
      end)
      |> List.flatten()

    {:ok, assign(socket, users: users)}
  end
end
