defmodule UntilMidnight.PostsTest do
  use UntilMidnight.DataCase

  alias UntilMidnight.Posts

  describe "posts" do
    alias UntilMidnight.Posts.Post

    import UntilMidnight.PostsFixtures

    @invalid_attrs %{
      description: nil,
      photo_url: nil,
      total_comments: nil,
      total_likes: nil,
      url_id: nil
    }

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{
        description: "some description",
        photo_url: "some photo_url",
        total_comments: 42,
        total_likes: 42,
        url_id: "some url_id"
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.description == "some description"
      assert post.photo_url == "some photo_url"
      assert post.total_comments == 42
      assert post.total_likes == 42
      assert post.url_id == "some url_id"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        description: "some updated description",
        photo_url: "some updated photo_url",
        total_comments: 43,
        total_likes: 43,
        url_id: "some updated url_id"
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.description == "some updated description"
      assert post.photo_url == "some updated photo_url"
      assert post.total_comments == 43
      assert post.total_likes == 43
      assert post.url_id == "some updated url_id"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
