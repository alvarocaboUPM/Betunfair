defmodule BetUnfair.Repo.Migrations.CreateBetsTable do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :bet_id, :integer
      add :user_id, references(:users)
      add :event_id, references(:events)
      add :amount, :float
      add :odds, :float
      add :bet_type, :string
      add :is_matched, :boolean
    end
  end
end
