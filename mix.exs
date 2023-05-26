defmodule Betunfair.MixProject do
  use Mix.Project

  def project do
    [
      app: :betunfair,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :dev,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Betunfair.Application, []},
      extra_applications: [:logger, :runtime_tools, :ecto_sql],
    ]
  end


  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Relational DBs ORM
      {:ecto, "~> 3.10"},
      {:ecto_sql, "~> 3.0"},
      {:myxql, "~> 0.6.0"},
      # Telegram wrapper
      {:ex_gram, "~> 0.40.0"},
      # HTTP handler
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      # JSON parser
      {:jason, ">= 1.0.0"}
    ]
  end
end
