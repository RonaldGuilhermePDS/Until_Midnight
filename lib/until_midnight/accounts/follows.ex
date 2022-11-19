defmodule UntilMidnight.Accounts.Follows do
  use Ecto.Schema
  import Ecto.Changeset

  alias UntilMidnight.Accounts.User

  schema "accounts_follows" do
    belongs_to :follower, User
    belongs_to :followed, User

    timestamps()
  end

  @doc false
  def changeset(follows, attrs) do
    follows
    |> cast(attrs, [])
    |> validate_required([])
  end
end
