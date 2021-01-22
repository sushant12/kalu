defmodule KaluWeb.OnlineUsersComponent do
  use KaluWeb, :live_component
  alias KaluWeb.Presence

  @impl true
  def render(assigns) do
    ~L"""
    <div class="column" id="online-users">
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
    Presence.track(self(), "room:#{assigns.room.name}", assigns.room.name, %{
      name: assigns.username
    })

    users =
      Presence.list("room:#{assigns.room.name}")
      |> Enum.map(fn {_topic, connected_users} ->
        connected_users[:metas]
      end)
      |> List.flatten()

    {:ok, socket |> assign(users: users)}
  end
end
