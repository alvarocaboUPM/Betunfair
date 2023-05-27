defmodule BetUnfair.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :username, :string
      add :full_name, :string
      add :password, :string
      add :wallet_balance, :float
    end
  end
end
