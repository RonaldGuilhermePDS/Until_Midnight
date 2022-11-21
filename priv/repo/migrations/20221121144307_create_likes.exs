defmodule UntilMidnight.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :liked_id, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:likes, [:user_id])
  end
end
