defmodule UntilMidnight.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias UntilMidnight.Repo

  alias UntilMidnight.Comments.Comment

  @doc """
  Returns paginated comments sorted by current user id or by id if public
  """
  def list_post_comments(assigns, public: public) do
    user = assigns.current_user
    post_id = assigns.post.id
    per_page = assigns.per_page
    page = assigns.page

    Comment
    |> where(post_id: ^post_id)
    |> get_post_comments_sorting(public, user)
    |> limit(^per_page)
    |> offset(^((page - 1) * per_page))
    |> preload([:user, :likes])
    |> Repo.all
  end

  defp get_post_comments_sorting(module, public, user) do
    if public do
      order_by(module, asc: :id)
    else
      order_by(module, fragment("(CASE WHEN user_id = ? then 1 else 2 end)", ^user.id))
    end
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id) do
    Repo.get!(Comment, id)
    |> Repo.preload([:user, :likes])
  end

  @doc """
  Creates a comment and updates total comments count in post
  Returns the comment created with likes preloaded
  """
  def create_comment(user, post, attrs \\ %{}) do
    update_total_comments = post.__struct__ |> where(id: ^post.id)
    comment_attrs = %Comment{} |> Comment.changeset(attrs)
    comment =
      comment_attrs
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Ecto.Changeset.put_assoc(:post, post)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:update_total_comments, update_total_comments, inc: [total_comments: 1])
    |> Ecto.Multi.insert(:comment, comment)
    |> Repo.transaction()
    |> case do
      {:ok, %{comment: comment}} ->
        comment |> Repo.preload(:likes)
    end
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
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
