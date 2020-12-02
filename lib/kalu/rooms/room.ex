defmodule Kalu.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kalu.Comments.Comment

  schema "rooms" do
    field :name, :string
    field :youtube_url, :string
    has_many :comments, Comment
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def update_changeset(room, attrs) do
    room
    |> cast(attrs, [:youtube_url])
    |> validate_required([:youtube_url])
  end
end
