defmodule Kalu.Repo do
  use Ecto.Repo,
    otp_app: :kalu,
    adapter: Ecto.Adapters.Postgres
end
