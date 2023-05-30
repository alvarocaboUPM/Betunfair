defmodule BetUnfair.Repo.Migrations.CreateBetsTable do
  use Ecto.Migration

    def change do
    create table(:bet, primary_key: false) do
      add :bet_id, :binary_id, primary_key: true
      add :bet_type, :string
      add :odds, :integer
      add :original_stake, :integer
      add :remaining_stake, :integer
      add :status, :string, default: "active"
      add :username, references(:user, column: :username, type: :string)
      add :market_name, references(:market, column: :market_name, type: :string)
      timestamps()
    end

    create table(:matched_bets) do
      add :bet_id, references(:bet, column: :bet_id, type: :binary_id)
      add :matched_bet_id, references(:bet, column: :bet_id, type: :binary_id)
      add :matched_amount, :integer
      timestamps()
    end

    create index(:matched_bets, [:bet_id])
    create index(:matched_bets, [:matched_bet_id])
  end
end
