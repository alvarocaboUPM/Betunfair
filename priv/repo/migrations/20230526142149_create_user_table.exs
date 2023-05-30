defmodule BetUnfair.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add :user_id, :binary_id, primary_key: true
      add :username, :string
      add :full_name, :string
      add :password, :string
      add :wallet_balance, :float

      timestamps()
    end
    create(unique_index(:user, [:username]))
  end
end
