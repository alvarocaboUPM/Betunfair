defmodule MyApp.Repo.Migrations.CreateMarketTable do
  use Ecto.Migration

  def change do
    create table(:market, primary_key: false) do
      add :market_name, :string, primary_key: true
      add :market_description, :string
      add :market_date, :utc_datetime
      add :status, :string

      timestamps()
    end
  end
end
