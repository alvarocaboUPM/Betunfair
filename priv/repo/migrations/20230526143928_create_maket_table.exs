defmodule BetUnfair.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  def change do
    create table(:market) do
      add :market_id, :integer
      add :market_name, :string
      add :market_description, :string
      add :market_date, :utc_datetime
      add :is_settled, :boolean
      add :outcome, :string
    end
  end
end
