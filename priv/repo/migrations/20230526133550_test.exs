defmodule BetUnfair.Repo.Migrations.Test do
  use Ecto.Migration

  def change do
    create table(:test) do
      add :dummy_1, :string
      add :dummy_2, :string
      add :age, :integer
    end
  end
end
