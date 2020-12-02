defmodule Kalu.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :youtube_url, :string

      timestamps()
    end

  end
end
