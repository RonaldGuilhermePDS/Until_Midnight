defmodule UntilMidnight.Repo.Migrations.AddToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :avatar, :string
      add :bio, :string
    end
  end
end
