# BetUnfair

BetUnfair is a marketplace where users can place bets against each other,rather than against a bookmaker

## Table of Contents

- [BetUnfair](#betunfair)
  - [Table of Contents](#table-of-contents)
  - [Documentation](#documentation)
  - [Development Setup](#development-setup)
    - [Prerequesites](#prerequesites)
    - [Database set-up and connection](#database-set-up-and-connection)
  - [Useful links](#useful-links)

## Documentation

At `docs` folder you can checkout information about the database:

- [Presentation]("https://github.com/alvarocaboUPM/Betunfair/blob/main/docs/presentation.pdf")
- [DB v.3]("https://github.com/alvarocaboUPM/Betunfair/blob/main/docs/betunfair_v3.pdf")

## Development Setup

### Prerequesites

If you are confortable with using docker, you can run a development
enviroment with this requesites with our Docker Image, which contains:

1. Elixir ^1.12
2. OTP ^24
3. MariaDB / MySQL server running
4. MariaDB / MySQL client

### Database set-up and connection

You can use the scrip `autobuildDB` to rebuild the databases on migration update or creation.
**Atention:** this script will erase the previous databases betunfair and betunfair_test

```bash
sudo ./utils/autobuildDB.sh
```

Or you can do it manually

1. Create the databases by running `utils/init.sql` as root
2. Run the migrations for the testing db

    ```bash
    MIX_ENV=dev mix ecto.migrate -r BetUnfair.Repo
    MIX_ENV=test mix ecto.migrate -r BetUnfair.Repo
    ```

3. You can test the connection by running:

   ```bash
    iex> MyApp.Repo.start_link()
    {:ok, #PID<0.198.0>}
    ```

## Useful links

- [Ecto start-up](https://hexdocs.pm/ecto/getting-started.html#adding-ecto-to-an-application)
- [Ecto-SQL](https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html)
- [Betfair Exchange Español](https://www.youtube.com/watch?v=OuwNoftd2ow)
