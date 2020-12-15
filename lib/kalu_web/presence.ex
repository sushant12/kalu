defmodule KaluWeb.Presence do
  use Phoenix.Presence, otp_app: :kalu, pubsub_server: Kalu.PubSub
end
