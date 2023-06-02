use Mix.Config

config :betunfair, ecto_repos: [BetUnfair.Repo]

config :betunfair, BetUnfair.Repo,
  log: false,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "betunfair_test",
  username: "betunfair",
  password: "9sX5^6a2jJng",
  hostname: "localhost",
  port: 3306
