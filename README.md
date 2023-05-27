# Betunfair

Betunfair is a marketplace where users can place bets against each other,rather than against a bookmaker

## Production Setup

### Database connection

1. Create the databases by running `utils/init.sql`
2. Run the migrations
  
   ```bash
    mix ecto.create && \
    mix ecto.migrate
    ```

3. You can test the connection by running:

   ```bash
    iex> MyApp.Repo.start_link()
    {:ok, #PID<0.198.0>}
    ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `betunfair` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:betunfair, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/betunfair](https://hexdocs.pm/betunfair).
