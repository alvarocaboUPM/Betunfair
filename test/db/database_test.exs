defmodule BetUnfairTest.DatabaseTest do
  use ExUnit.Case

  # Ensure the Ecto repository is started before running the tests
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BetUnfair.Repo)
  end

  test "database connection" do
    assert {:ok, _} = BetUnfair.Repo.ping()
  end
end
