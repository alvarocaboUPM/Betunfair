defmodule BetUnfair.Repo.Migrations.UpdateBetsTable do
  use Ecto.Migration

  def change do
    alter table(:bet) do
      add :user_id, references(:user)
      add :market_id, references(:market)
    end
  end
end
