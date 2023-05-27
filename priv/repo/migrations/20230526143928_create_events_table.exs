defmodule BetUnfair.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_id, :integer
      add :event_name, :string
      add :event_description, :string
      add :event_date, :utc_datetime
      add :is_settled, :boolean
      add :outcome, :string
    end
  end
end
