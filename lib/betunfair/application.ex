defmodule Betunfair.Application do
  use Application

  def start(_type, _args) do
    children = [
      Betunfair.Repo,
      {Betunfair, []} # Assuming Betunfair.start_link/1 is properly defined
    ]

    opts = [strategy: :one_for_one, name: Betunfair.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
