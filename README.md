# BetUnfair

BetUnfair is a marketplace where users can place bets against each other,rather than against a bookmaker

## Table of Contents

- [BetUnfair](#betunfair)
  - [Table of Contents](#table-of-contents)
  - [Documentation](#documentation)
  - [Development Setup](#development-setup)
    - [Prerequesites](#prerequesites)
    - [Database set-up and connection](#database-set-up-and-connection)
    - [Database connection (Manual)](#database-connection-manual)
  - [Useful documentation](#useful-documentation)

## Documentation

At `docs` folder you can checkout information about the database:

- [Presentation]("docs/presentation.pdf")
- [DB v.3]("docs/betunfair_v3.pdf")

## Development Setup

### Prerequesites

If you are confortable with using docker, you can run a development
enviroment with this requesites with our Docker Image

1. Elixir ^1.12
2. OTP ^24
3. MariaDB / MySQL server running
4. MariaDB / MySQL client

### Database set-up and connection

You can use the scrip `autobuildDB` to rebuild the databases on migration update or creation

```bash
sudo ./utils/autobuildDB.sh
```

### Database connection (Manual)

1. Create the databases by running `utils/init.sql`
2. Run the migrations for the testing db
  
   ```bash
    export MIX_ENV=test && \
    mix ecto.create && \
    mix ecto.migrate && \
    export MIX_ENV=dev
    ```

3. Run the migrations for prod db
  
   ```bash
    mix ecto.create && \
    mix ecto.migrate
    ```

4. You can test the connection by running:

   ```bash
    iex> MyApp.Repo.start_link()
    {:ok, #PID<0.198.0>}
    ```

## Useful documentation

- [Ecto start-up](https://hexdocs.pm/ecto/getting-started.html#adding-ecto-to-an-application)
- [Ecto-SQL](https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html)
- [Betfair Exchange Español](https://www.youtube.com/watch?v=OuwNoftd2ow)
