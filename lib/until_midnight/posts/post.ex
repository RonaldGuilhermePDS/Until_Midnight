defmodule UntilMidnight.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :description, :string
    field :photo_url, :string
    field :url_id, :string
    field :total_likes, :integer, default: 0
    field :total_comments, :integer, default: 0
    has_many :likes, UntilMidnight.Likes.Like, foreign_key: :liked_id
    has_many :comments, UntilMidnight.Comments.Comment
    belongs_to :user, UntilMidnight.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:url_id, :description, :photo_url])
    |> validate_required([:url_id, :photo_url])
  end
end
