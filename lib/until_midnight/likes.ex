defmodule UntilMidnight.Likes do
  @moduledoc """
  The Likes context.
  """

  import Ecto.Query, warn: false

  alias UntilMidnight.Repo
  alias UntilMidnight.Likes.Like

  @doc """
  Creates like.
  """
  def create_like(user, liked) do
    user = Ecto.build_assoc(user, :likes)
    like = Ecto.build_assoc(liked, :likes, user)
    update_total_likes = liked.__struct__ |> where(id: ^liked.id)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:like, like)
    |> Ecto.Multi.update_all(:update_total_likes, update_total_likes, inc: [total_likes: 1])
    |> Repo.transaction()
  end

  @doc """
  Checkes if liked.
  """
  def liked?(user_id, liked_id) do
    Repo.get_by(Like, user_id: user_id, liked_id: liked_id)
  end

  @doc """
  Deletes like.
  """
  def unlike(user_id, liked) do
    like = liked?(user_id, liked.id)
    update_total_likes = liked.__struct__ |> where(id: ^liked.id)

    Ecto.Multi.new()
    |> Ecto.Multi.delete(:like, like)
    |> Ecto.Multi.update_all(:update_total_likes, update_total_likes, inc: [total_likes: -1])
    |> Repo.transaction()
  end
end
