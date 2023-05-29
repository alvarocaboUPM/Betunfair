defmodule BetUnfair do
  use GenServer

  ## Client API

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: BetUnfair)
  end

  def stop(name) do
    GenServer.stop(name)
  end

  def clean(name) do
    if Mix.env() == :test do
      clearDB()
    end

    stop(name)
  end

  def clearDB() do
    # Ensure the BetUnfair.Repo is started
    {:error, {:already_started, _}} = BetUnfair.Repo.start_link()

    # Delete all records from the tables in the database
    BetUnfair.Repo.transaction(fn ->
      Ecto.Adapters.SQL.query!(BetUnfair.Repo, "DELETE FROM user")
      Ecto.Adapters.SQL.query!(BetUnfair.Repo, "DELETE FROM market")
      Ecto.Adapters.SQL.query!(BetUnfair.Repo, "DELETE FROM bet")
      Ecto.Adapters.SQL.query!(BetUnfair.Repo, "ALTER TABLE user AUTO_INCREMENT = 1")
      Ecto.Adapters.SQL.query!(BetUnfair.Repo, "ALTER TABLE market AUTO_INCREMENT = 1")
      Ecto.Adapters.SQL.query!(BetUnfair.Repo, "ALTER TABLE bet AUTO_INCREMENT = 1")
    end)
    :ok
  end

  ## User API

  def user_create(username, full_name) do
    GenServer.call(__MODULE__, {:user_create, username, full_name})
  end

  def user_deposit(user, amount) do
    GenServer.call(__MODULE__, {:user_deposit, user, amount})
  end

  def user_withdraw(user, amount) do
    GenServer.call(__MODULE__, {:user_withdraw, user, amount})
  end

  def user_get(user) do
    GenServer.call(__MODULE__, {:user_get, user})
  end

  def user_bets(user) do
    GenServer.call(__MODULE__, {:user_get, user})
  end

  def user_get_balance(user) do
    GenServer.call(__MODULE__, {:user_get_balance, user})
  end

  ## Market API

  def market_create(name, description) do
    GenServer.call(__MODULE__, {:market_create, name, description})
  end

  def market_list() do
    GenServer.call(__MODULE__, :market_list)
  end

  def market_list_active() do
    GenServer.call(__MODULE__, :market_list_active)
  end

  def market_cancel(id) do
    GenServer.call(__MODULE__, {:market_cancel, id})
  end

  def market_freeze(id) do
    GenServer.call(__MODULE__, {:market_freeze, id})
  end

  def market_settle(id, result) do
    GenServer.call(__MODULE__, {:market_settle, id, result})
  end

  def market_bets(id) do
    GenServer.call(__MODULE__, {:market_bets, id})
  end

  def market_get(id) do
    GenServer.call(__MODULE__, {:market_get, id})
  end

    ## BET API

  def bet_back(user, market, stake, odds) do
    GenServer.call(__MODULE__, {:bet_back, user, market, stake, odds})
  end

  def bet_lay(user, market, stake, odds) do
    GenServer.call(__MODULE__, {:bet_lay, user, market, stake, odds})
  end

  def bet_cancel(bet_id) do
    GenServer.call(__MODULE__, {:bet_cancel, bet_id})
  end

  def bet_get(bet_id) do
    GenServer.call(__MODULE__, {:bet_get, bet_id})
  end

  ## Server Callbacks

  @impl true
  def init(name) do
    {:ok, %{name: name}}
  end

  @impl true
  def handle_call({:user_create, username, full_name}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.User.user_create(username, full_name)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:user_withdraw, user, amount}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.User.user_withdraw(user, amount)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:user_deposit, user, amount}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.User.user_deposit(user, amount)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:user_get, user}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.User.user_get(user)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:user_bets, user}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.User.user_bets(user)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:user_get_balance, user}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.User.user_get_balance(user)

    {:reply, result, state}
  end

    ## BET

  @impl true
  def handle_call({:bet_back, user, market, stake, odds}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Bet.bet_back(user, market, stake, odds)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:bet_lay, user, market, stake, odds}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Bet.bet_lay(user, market, stake, odds)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:bet_cancel, bet_id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Bet.bet_cancel(bet_id)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:bet_get, bet_id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Bet.bet_get(bet_id)

    {:reply, result, state}
  end


  # Market

  @impl true
  def handle_call({:market_create, name, description}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_create(name, description)

    {:reply, result, state}
  end

  @impl true
  def handle_call(:market_list, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_list()

    {:reply, result, state}
  end

  @impl true
  def handle_call(:market_list_active, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_list_active()

    {:reply, result, state}
  end

  @impl true
  def handle_call({:market_cancel, id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_cancel(id)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:market_freeze, id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_freeze(id)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:market_bets, id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_bets(id)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:market_pending_backs, id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_pending_backs(id)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:market_match, id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_match(id)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:market_get, id}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_get(id)

    {:reply, result, state}
  end

  @impl true
  def handle_call({:market_settle, id, result}, _from, state) do
    # Forward the call to the appropriate controller function
    result = BetUnfair.Controllers.Market.market_settle(id, result)

    {:reply, result, state}
  end
end
