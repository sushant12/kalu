defmodule Kalu.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kalu.Rooms.Room

  schema "comments" do
    field :message, :string
    field :name, :string
    belongs_to :room, Room
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:name, :message, :room_id])
    |> validate_required([:name, :message, :room_id])
  end
end
