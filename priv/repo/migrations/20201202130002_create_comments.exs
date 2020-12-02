defmodule Kalu.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :name, :string
      add :message, :text
      add :room_id, references("rooms", on_delete: :delete_all)
      timestamps()
    end
  end
end
