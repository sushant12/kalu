defmodule KaluWeb.MessageComponent do
  use KaluWeb, :live_component
  alias Kalu.Comments

  @impl true
  def render(assigns) do
    ~L"""
    <div class="chat-content">
      <h3>Chat</h3>
      <%= for message <- @messages do %>
        <div class="message">
          <%= message.name %>:  <%= message.message %>
        </div>
      <% end %>
    </div>
    <div class="chat-input">
      <%= f = form_for @message, "#", phx_target: @myself, phx_submit: :send_message, id: "chat-form"%>
        <%= textarea f, :message %>
        <div>
          <%= submit "Send" %>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def handle_event("send_message", %{"comment" => message}, socket) do
    room_name = socket.assigns.room.name

    {:ok, comment} =
      Comments.create_comment(%{
        message: message["message"],
        name: socket.assigns.username,
        room_id: socket.assigns.room.id
      })

    messages = Comments.list_comments(socket.assigns.room.id) |> Enum.reverse()

    KaluWeb.Endpoint.broadcast_from(self(), "room:#{room_name}", "message_sent", %{
      room_name: room_name,
      messages: messages
    })

    {:noreply, assign(socket, messages: messages)}
  end
end
