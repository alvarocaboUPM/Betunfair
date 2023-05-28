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
end
