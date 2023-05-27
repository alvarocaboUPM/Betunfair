defmodule BetUnfair do
  use GenServer

  ## Client API

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: Betunfair)
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
