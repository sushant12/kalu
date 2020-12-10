defmodule Kalu.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kalu.Comments.Comment

  @youtube_url_regex ~r/http(s)?:\/\/www\.youtube\.com\/watch\?v=/
  schema "rooms" do
    field :name, :string
    field :youtube_video_id, :string
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
    |> cast(attrs, [:youtube_video_id])
    |> validate_required([:youtube_video_id])
    |> validate_format(:youtube_video_id, @youtube_url_regex)
    |> extract_video_id()
  end

  defp extract_video_id(
         %Ecto.Changeset{valid?: true, changes: %{youtube_video_id: youtube_video_id}} = changeset
       ) do
    change(changeset, %{
      youtube_video_id: String.replace(youtube_video_id, @youtube_url_regex, "")
    })
  end

  defp extract_video_id(changeset), do: changeset
end
