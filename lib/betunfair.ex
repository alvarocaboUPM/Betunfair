defmodule BetUnfair do
  use GenServer

  ## Client API

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def stop(name) do
    GenServer.stop(name)
  end

  def clean(name) do
    # TODO: Handle closing DB connection
    stop(name)
  end

  ## Server Callbacks

  def init(name) do
    {:ok, %{name: name}}
  end
end
