defmodule BetUnfair.Controllers.Bet do
  @type bet_id() :: String.t()
  @type market_id() :: String.t()
  @type user_id() :: String.t()

  @doc """
  Creates a new backing bet by a user and in a market

  ## Examples

    assert {:ok, 1} = BetUnfair.bet_back("user", 1, 25, 1.5)

  """
  @spec bet_back(
          user_id(),
          market_id(),
          number(),
          number()
        ) :: {:ok, bet_id()}
  def bet_back(user_id, market_id, stake, odds) do
    # check if user exists
    case BetUnfair.Controllers.User.user_get(user_id) do
      {:ok, user_data} ->
        # check if market exists
        case BetUnfair.Controllers.Market.market_get(market_id) do
          {:ok, market} ->
            # check user balance, if enough, reduce it
            {_, balance} = BetUnfair.Controllers.User.user_get_balance(user_id)

            if balance >= stake do
              # substract money from user
              new_balance = balance - stake

              changeset =
                BetUnfair.Schemas.User.changeset(
                  user_data,
                  %{
                    balance: new_balance
                  }
                )

              case BetUnfair.Repo.update(changeset) do
                {:ok, _} ->
                  # create bet
                  changeset1 =
                    BetUnfair.Schemas.Bet.changeset(
                      %BetUnfair.Schemas.Bet{},
                      %{
                        username: user_data.username,
                        market_name: market.market_name,
                        original_stake: stake,
                        stake: stake,
                        odds: odds,
                        bet_type: :back,
                        matched_bets: nil
                      }
                    )

                  # insert into database
                  case BetUnfair.Repo.insert(changeset1) do
                    {:ok, bet} -> {:ok, bet.id}
                    {:error, changeset1} -> {:error, changeset1}
                  end

                {:error, changeset} ->
                  {:error, changeset}
              end
            else
              {:error, "Insuficient funds"}
            end

          {:error, reason} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Creates a new laying bet by a user and in a market

  ## Examples

    assert {:ok, 1} = BetUnfair.bet_lay("user", 1, 25, 1.5)

  """
  @spec bet_lay(
          user_id(),
          market_id(),
          number(),
          number()
        ) :: {:ok, bet_id()}
  def bet_lay(user_id, market_id, stake, odds) do
    # check if user exists
    case BetUnfair.Controllers.User.user_get(user_id) do
      {:ok, user_data} ->
        # check if market exists
        case BetUnfair.Controllers.Market.market_get(market_id) do
          {:ok, market} ->
            # check user balance, if enough, reduce it
            {_, balance} = BetUnfair.Controllers.User.user_get_balance(user_id)

            if balance >= stake do
              # can bet

              # substract money from user
              new_balance = balance - stake

              changeset =
                BetUnfair.Schemas.User.changeset(
                  user_data,
                  %{
                    balance: new_balance
                  }
                )

              case BetUnfair.Repo.update(changeset) do
                {:ok, _} ->
                  # create bet
                  changeset1 =
                    BetUnfair.Schemas.Bet.changeset(
                      %BetUnfair.Schemas.Bet{},
                      %{
                        username: user_data.username,
                        market_name: market.market_name,
                        original_stake: stake,
                        stake: stake,
                        odds: odds,
                        bet_type: :lay,
                        matched_bets: nil
                      }
                    )

                  # insert into database
                  case BetUnfair.Repo.insert(changeset1) do
                    {:ok, bet} -> {:ok, bet.id}
                    {:error, changeset1} -> {:error, changeset1}
                  end

                {:error, changeset} ->
                  {:error, changeset}
              end
            else
              {:error, "Insuficient funds"}
            end

          {:error, reason} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Cancels the parts of a bet that have not been matched

  ## Examples

    assert :ok = BetUnfair.bet_cancel(1)

  """
  @spec bet_cancel(bet_id()) :: :ok
  def bet_cancel(id) do
    case BetUnfair.Controllers.Bet.bet_get(id) do
      {:ok, bet} ->
        # change status and remove unmatched stake
        change = BetUnfair.Schemas.Bet.changeset(bet, %{status: :cancelled, stake: 0})

        case BetUnfair.Repo.update(change) do
          {:ok, _} -> :ok
          {:error, changeset} -> {:error, "Failed to update bet: #{inspect(changeset.errors)}"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Gets current information about the state of a bet

  ## Examples

    assert {:ok, %{bet_type: :back,
                   market_id: market,
                   user_id: user,
                   odds: 1.5,
                   original_stake: 20,
                   remaining_stake: 2,
                   matched_bets: [2, 3],
                   status: :active}} = BetUnfair.bet_get(bet)

  """
  @spec bet_get(bet_id()) :: {:ok, bet_id()}
  def bet_get(id) do
    case BetUnfair.Repo.get_by(BetUnfair.Schemas.Bet, id: id) do
      nil ->
        {:error, "Bet not found"}

      bet_data ->
        {:ok, bet_data}
    end
  end
end
