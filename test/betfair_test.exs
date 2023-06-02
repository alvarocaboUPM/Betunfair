defmodule BetUnfairBetFairTest do
  use ExUnit.Case, async: true

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BetUnfair.Repo)
    # Setting the shared mode must be done only after checkout
    Ecto.Adapters.SQL.Sandbox.mode(BetUnfair.Repo, {:shared, self()})
  end

  test "documentation-test" do
    #Create the users
    assert {:ok,a} = BetUnfair.user_create("a","A")
    assert is_ok(BetUnfair.user_deposit(a,200000))
    assert {:ok,b} = BetUnfair.user_create("b","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(b,200000))
    assert {:ok,c} = BetUnfair.user_create("c","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(c,200000))
    assert {:ok,d} = BetUnfair.user_create("d","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(d,200000))
    assert {:ok,e} = BetUnfair.user_create("e","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(e,200000))
    assert {:ok,f} = BetUnfair.user_create("f","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(f,200000))
    assert {:ok,g} = BetUnfair.user_create("g","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(g,200000))
    # Original state
    assert {:ok,m1} = BetUnfair.market_create("me","Main Event")
    assert {:ok,_bba} = BetUnfair.bet_back(a,m1,2000,300)
    assert {:ok,_bbb} = BetUnfair.bet_back(b,m1,1400,200)
    assert {:ok,bbc} = BetUnfair.bet_back(c,m1,500,153)
    assert {:ok,_bld} = BetUnfair.bet_lay(d,m1,2100,150)
    assert {:ok,_ble} = BetUnfair.bet_lay(e,m1,40000,110)
    # Case 1
    assert {:ok,bbf} = BetUnfair.bet_back(f,m1,5000,150)
    assert is_ok(BetUnfair.market_match(m1))
    assert {:ok,%{stake: 800}} = BetUnfair.bet_get(bbf)
    # Case 2
    assert {:ok,blg} = BetUnfair.bet_lay(g,m1,500,153)
    assert is_ok(BetUnfair.market_match(m1))
    assert {:ok,%{stake: 0}} = BetUnfair.bet_get(blg)
    assert {:ok,%{stake: 0}} = BetUnfair.bet_get(bbf)
    assert {:ok,%{stake: 311}} = BetUnfair.bet_get(bbc)

  end

  defp is_error(:error),do: true
  defp is_error({:error,_}), do: true
  defp is_error(_), do: false

  defp is_ok(:ok), do: true
  defp is_ok({:ok,_}), do: true
  defp is_ok(_), do: false
end
