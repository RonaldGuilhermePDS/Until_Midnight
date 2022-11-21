defmodule UntilMidnight.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :total_likes, :integer, default: 0
    belongs_to :post, UntilMidnight.Posts.Post
    belongs_to :user, UntilMidnight.Accounts.User
    has_many :likes, UntilMidnight.Likes.Like, foreign_key: :liked_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
