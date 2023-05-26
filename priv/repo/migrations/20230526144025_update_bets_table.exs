defmodule BetUnfair.Repo.Migrations.UpdateBetsTable do
  use Ecto.Migration

  def change do
    alter table(:bets) do
      add :user_id, references(:users)
      add :event_id, references(:events)
    end
  end
end
