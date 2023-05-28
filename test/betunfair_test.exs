defmodule BetunfairTest do
  use ExUnit.Case, async: true

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BetUnfair.Repo)
    # Setting the shared mode must be done only after checkout
    Ecto.Adapters.SQL.Sandbox.mode(BetUnfair.Repo, {:shared, self()})
  end

  test "user_operations" do
    assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
    assert is_ok(BetUnfair.user_deposit(u1,2000))
    assert is_error(BetUnfair.user_deposit(u1,-1))
    assert is_error(BetUnfair.user_deposit(u1,0))
    assert is_error(BetUnfair.user_deposit("u11",0))
    assert is_ok(BetUnfair.user_withdraw(u1,1000))
    assert is_error(BetUnfair.user_withdraw(u1,-1))
    assert is_error(BetUnfair.user_withdraw(u1, 0))
    assert is_error(BetUnfair.user_withdraw(u1, 50000))
    assert {:ok,1000.0} = BetUnfair.user_get_balance(u1)
    case BetUnfair.user_get(u1) do
      {:ok, fetched_user} ->
        # Assert that the fetched user matches the expected user attributes
        assert %BetUnfair.Schemas.User{
                 __meta__: _,
                 full_name: "Francisco Gonzalez",
                 password: nil,
                 username: "u1",
                 wallet_balance: 1000.0
               } = fetched_user

      {:error, _} ->
        flunk "Failed to fetch user"
    end
  end

    # test "user_persist" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,b} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,%{id: ^b, bet_type: :back, stake: 1000, odds: 150, status: :active}} = BetUnfair.bet_get(b)
  #   assert is_ok(BetUnfair.stop())
  #   assert  {:ok,_} = BetUnfair.start_link(BetUnfair)
  #   assert {:ok,%{balance: 1000}} = BetUnfair.user_get(u1)
  #   assert {:ok,markets} = BetUnfair.market_list()
  #   assert 1 = length(markets)
  #   assert {:ok,markets} = BetUnfair.market_list_active()
  #   assert 1 = length(markets)
  # end

  # test "user_bet1" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,b} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,%{id: ^b, bet_type: :back, stake: 1000, odds: 150, status: :active}} = BetUnfair.bet_get(b)
  #   assert {:ok,markets} = BetUnfair.market_list()
  #   assert 1 = length(markets)
  #   assert {:ok,markets} = BetUnfair.market_list_active()
  #   assert 1 = length(markets)
  # end



  # test "match_bets1" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,bl1} = BetUnfair.bet_lay(u2,m1,500,140)
  #   assert {:ok,bl2} = BetUnfair.bet_lay(u2,m1,500,150)
  #   assert {:ok,%{balance: 1000}} = BetUnfair.user_get(u2)
  #   assert {:ok, backs} = BetUnfair.market_pending_backs(m1)
  #   assert [^bb1,^bb2] = Enum.to_list(backs) |> Enum.map(fn (e) -> elem(e,1) end)
  #   assert {:ok,lays} = BetUnfair.market_pending_lays(m1)
  #   assert [^bl2,^bl1] = Enum.to_list(lays) |> Enum.map(fn (e) -> elem(e,1) end)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert {:ok,%{stake: 0}} = BetUnfair.bet_get(bb1)
  #   assert {:ok,%{stake: 0}} = BetUnfair.bet_get(bl2)
  # end

  # test "match_bets2" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,1000,140)
  #   assert {:ok,bl2} = BetUnfair.bet_lay(u2,m1,1000,150)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert {:ok,%{stake: 0}} = BetUnfair.bet_get(bb1)
  #   assert {:ok,%{stake: 500}} = BetUnfair.bet_get(bl2)
  # end

  # test "match_bets3" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert {:ok,%{stake: 800}} = BetUnfair.bet_get(bb1)
  #   assert {:ok,%{stake: 0}} = BetUnfair.bet_get(bl2)
  #   assert {:ok,user_bets} = BetUnfair.user_bets(u1)
  #   assert 2 = length(user_bets)
  # end

  # test "match_bets4" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_cancel(m1))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,%{balance: 2000.0}} = BetUnfair.user_get(u2)
  # end

  # test "match_bets5" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_settle(m1,true))
  #   assert {:ok,%{balance: 2100}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 1900}} = BetUnfair.user_get(u2)
  # end

  # test "match_bets6" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_settle(m1,false))
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 2200}} = BetUnfair.user_get(u2)
  # end

  # test "match_bets7" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_freeze(m1))
  #   assert is_error(BetUnfair.bet_lay(u2,m1,100,150))
  #   assert is_ok(BetUnfair.market_settle(m1,false))
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 2200}} = BetUnfair.user_get(u2)
  # end

  # test "match_bets8" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,200,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,200,153)
  #   assert {:ok,%{balance: 1600}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_settle(m1,true))
  #   assert {:ok,%{balance: 2100}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 1900}} = BetUnfair.user_get(u2)
  # end

  # test "match_bets9" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,200,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,200,153)
  #   assert {:ok,%{balance: 1600}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_settle(m1,false))
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 2200}} = BetUnfair.user_get(u2)
  # end

  # test "match_bets10" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,800,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,800,153)
  #   assert {:ok,%{balance: 400}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_settle(m1,true))
  #   assert {:ok,%{balance: 2200}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  # end

  # test "match_bets11" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,200,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,200,150)
  #   assert {:ok,%{balance: 1600}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,_bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,_bl2} = BetUnfair.bet_lay(u2,m1,800,150)
  #   assert {:ok,%{balance: 1100}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.market_settle(m1,false))
  #   assert {:ok,%{balance: 1600}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 2400}} = BetUnfair.user_get(u2)
  # end

  # test "bet_cancel1" do
  #   assert {:ok,u1} = BetUnfair.user_create("u1","Francisco Gonzalez")
  #   assert {:ok,u2} = BetUnfair.user_create("u2","Maria Fernandez")
  #   assert is_ok(BetUnfair.user_deposit(u1,2000))
  #   assert is_ok(BetUnfair.user_deposit(u2,2000))
  #   assert {:ok, 2000.0} = BetUnfair.user_get_balance(u1)
  #   assert {:ok,m1} = BetUnfair.market_create("rmw","Real Madrid wins")
  #   assert {:ok,bb1} = BetUnfair.bet_back(u1,m1,1000,150)
  #   assert {:ok,bb2} = BetUnfair.bet_back(u1,m1,1000,153)
  #   assert {:ok,%{balance: 0}} = BetUnfair.user_get(u1)
  #   assert true = (bb1 != bb2)
  #   assert {:ok,bl1} = BetUnfair.bet_lay(u2,m1,100,140)
  #   assert {:ok,bl2} = BetUnfair.bet_lay(u2,m1,100,150)
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_match(m1))
  #   assert is_ok(BetUnfair.bet_cancel(bl1))
  #   assert is_ok(BetUnfair.bet_cancel(bb2))
  #   assert {:ok,%{balance: 1000}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 1900}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.bet_cancel(bl2))
  #   assert is_ok(BetUnfair.bet_cancel(bb1))
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 1900}} = BetUnfair.user_get(u2)
  #   assert is_ok(BetUnfair.market_settle(m1,false))
  #   assert {:ok,%{balance: 1800}} = BetUnfair.user_get(u1)
  #   assert {:ok,%{balance: 2200}} = BetUnfair.user_get(u2)
  # end

  defp is_error(:error), do: true
  defp is_error({:error, _}), do: true
  defp is_error(_), do: false

  defp is_ok(:ok), do: true
  defp is_ok({:ok, _}), do: true
  defp is_ok(_), do: false
end
