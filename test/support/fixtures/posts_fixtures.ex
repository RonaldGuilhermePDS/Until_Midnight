defmodule UntilMidnight.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UntilMidnight.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        description: "some description",
        photo_url: "some photo_url",
        total_comments: 42,
        total_likes: 42,
        url_id: "some url_id"
      })
      |> UntilMidnight.Posts.create_post()

    post
  end
end
