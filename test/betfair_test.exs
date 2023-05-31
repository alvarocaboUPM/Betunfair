defmodule BetUnfairBetFairTest do
  use ExUnit.Case, async: true

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BetUnfair.Repo)
    # Setting the shared mode must be done only after checkout
    Ecto.Adapters.SQL.Sandbox.mode(BetUnfair.Repo, {:shared, self()})
  end

  test "miami-nuggets-test" do
    assert {:ok,u1} = BetUnfair.user_create("u1","Alvaro Cabo")
    assert {:ok,u2} = BetUnfair.user_create("u2","Not Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(u1,2000))
    assert is_ok(BetUnfair.user_deposit(u2,2000))
    assert {:ok,m1} = BetUnfair.market_create("mhw","Miami Heat wins")
    #Estado original
    assert {:ok,b} = BetUnfair.bet_back(u1,m1,22,450)
    assert {:ok,%{bet_id: ^b, bet_type: :back, stake: 22, odds: 450, status: :active}} = BetUnfair.bet_get(b)
    assert {:ok,b} = BetUnfair.bet_lay(u1,m1,22,450)
    assert {:ok,%{bet_id: ^b, bet_type: :back, stake: 87, odds: 470, status: :active}} = BetUnfair.bet_get(b)

  end

  test "documentation-test" do
    #Create the users
    assert {:ok,a} = BetUnfair.user_create("a","A")
    assert is_ok(BetUnfair.user_deposit(a,2000))
    assert {:ok,b} = BetUnfair.user_create("b","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(b,2000))
    assert {:ok,c} = BetUnfair.user_create("c","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(c,2000))
    assert {:ok,d} = BetUnfair.user_create("d","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(d,2000))
    assert {:ok,e} = BetUnfair.user_create("e","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(e,2000))
    assert {:ok,f} = BetUnfair.user_create("f","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(f,2000))
    assert {:ok,g} = BetUnfair.user_create("g","Alvaro Cabo")
    assert is_ok(BetUnfair.user_deposit(g,2000))
    # Original state
    assert {:ok,m1} = BetUnfair.market_create("me","Main Event")
    assert {:ok,bba} = BetUnfair.bet_back(a,m1,20,300)
    assert {:ok,bbb} = BetUnfair.bet_back(b,m1,14,200)
    assert {:ok,bbc} = BetUnfair.bet_back(c,m1,5,153)
    assert {:ok,bld} = BetUnfair.bet_lay(d,m1,21,150)
    assert {:ok,ble} = BetUnfair.bet_lay(e,m1,400,110)
    # Case 1
    assert {:ok,bbf} = BetUnfair.bet_back(f,m1,50,150)
    assert is_ok(BetUnfair.market_match(m1))
    assert {:ok,%{stake: 8}} = BetUnfair.bet_get(bbf)
    # Case 2
    assert {:ok,blg} = BetUnfair.bet_lay(f,m1,50,150)
    assert is_ok(BetUnfair.market_match(m1))
    assert {:ok,%{stake: 0}} = BetUnfair.bet_get(blg)
    assert {:ok,%{stake: 0}} = BetUnfair.bet_get(bbf)

  end

  defp is_error(:error),do: true
  defp is_error({:error,_}), do: true
  defp is_error(_), do: false

  defp is_ok(:ok), do: true
  defp is_ok({:ok,_}), do: true
  defp is_ok(_), do: false
end
