defmodule Kalu.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Kalu.Repo

  alias Kalu.Comments.Comment

  @doc """
  Returns the last 10 list of comments for a room.

  ## Examples

      iex> list_comments(1)
      [%Comment{}, ...]

  """
  def list_comments(room_id) when is_integer(room_id) do
    query =
      from c in Comment, where: c.room_id == ^room_id, limit: 10, order_by: [desc: c.inserted_at]

    Repo.all(query)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
