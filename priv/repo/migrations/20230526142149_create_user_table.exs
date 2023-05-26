defmodule BetUnfair.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_id, :integer
      add :username, :string
      add :password, :string
      add :wallet_balance, :float
    end
  end
end
