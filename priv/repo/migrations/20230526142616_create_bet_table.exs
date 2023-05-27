defmodule BetUnfair.Repo.Migrations.CreateBetsTable do
  use Ecto.Migration

  def change do
    create table(:bet) do
      add :bet_id, :integer
      add :amount, :float
      add :odds, :float
      add :bet_type, :string
      add :is_matched, :boolean
    end
  end
end
