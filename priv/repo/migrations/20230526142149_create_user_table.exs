defmodule BetUnfair.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add :username, :string, primary_key: true
      add :full_name, :string
      add :password, :string
      add :wallet_balance, :float

      timestamps()
    end
  end
end
