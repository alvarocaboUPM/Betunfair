defmodule BetUnfair.Application do
  use Application

  def start(_type, _args) do
    children = [
      BetUnfair.Repo,
      {Betunfair, []} # Assuming BetUnfair.start_link/1 is properly defined
    ]

    opts = [strategy: :one_for_one, name: BetUnfair.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
