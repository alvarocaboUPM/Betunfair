defmodule MyApp.Repo.Migrations.CreateMarketTable do
  use Ecto.Migration

  def change do
    create table(:market, primary_key: false) do
      add :market_id, :binary_id, primary_key: true
      add :market_name, :string
      add :market_description, :string
      add :market_date, :utc_datetime
      add :status, :string

      timestamps()
    end
    create(unique_index(:market, [:market_name]))
  end
end
