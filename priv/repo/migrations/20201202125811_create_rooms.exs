defmodule Kalu.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :youtube_video_id, :string

      timestamps()
    end

  end
end
