defmodule BetUnfair.Repo.Migrations.CreateBetsTable do
  use Ecto.Migration

  def change do
    create table(:bet) do
      add :amount, :float
      add :odds, :float
      add :bet_type, :string
      add :is_matched, :boolean
      add :username, references(:user, column: :username, type: :string)
      add :market_name, references(:market, column: :market_name, type: :string)
      timestamps()
    end
  end
end
