defmodule Kalu.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Kalu.Repo,
      # Start the Telemetry supervisor
      KaluWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Kalu.PubSub},
      # Start the Endpoint (http/https)
      KaluWeb.Endpoint
      # Start a worker by calling: Kalu.Worker.start_link(arg)
      # {Kalu.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kalu.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    KaluWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
