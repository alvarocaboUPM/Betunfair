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
    # TODO: Handle closing DB connection
    stop(name)
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

end
