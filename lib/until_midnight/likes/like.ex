defmodule UntilMidnight.Likes.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    field :liked_id, :integer

    belongs_to :user, UntilMidnight.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:liked_id])
    |> validate_required([:liked_id])
  end
end
