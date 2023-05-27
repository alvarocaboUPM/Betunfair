# Betunfair

Betunfair is a marketplace where users can place bets against each other,rather than against a bookmaker

## Dev Setup

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

## Useful documentation

- [Ecto start-up](https://hexdocs.pm/ecto/getting-started.html#adding-ecto-to-an-application)
- [Ecto-SQL](https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html)
  