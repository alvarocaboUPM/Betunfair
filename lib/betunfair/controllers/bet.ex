defmodule BetUnfair.Controllers.Bet do

  @doc """
  Creates a new backing bet by a user and in a market

  ## Examples

    assert {:ok, 1} = Betunfair.bet_back("user", 1, 25, 1.5)

  """
  @spec bet_back(String.t(),
                 number(),
                 number(),
                 number()) :: {:ok, map()}
  def bet_back(user_id, market_id, stake, odds) do

    # check if user exists
    case BetUnfair.Controllers.User.user_get(user_id) do
      {:ok, user_data} ->
        # check if market exists
        case BetUnfair.Controllers.Market.market_get(market_id) do
          {:ok, _} ->
            # check user balance, if enough, reduce it
            {_, balance} = BetUnfair.Controllers.User.user_get_balance(user_data)

              if balance >= stake do
                # substract money from user
                new_balance = balance - (stake/1)
                changeset =
                  BetUnfair.Schemas.User.changeset(
                    user_data, #Esto lo arregla
                    %{
                      wallet_balance: new_balance
                    }
                  )

                case BetUnfair.Repo.update(changeset) do
                  {:ok, _} ->
                    # create bet
                    changeset1 = BetUnfair.Schemas.Bet.changeset(
                      %BetUnfair.Schemas.Bet{},
                        %{
                          username: user_id.username,
                          market_name: market_id.market_name,
                          original_stake: stake,
                          remaining_stake: stake,
                          odds: odds,
                          bet_type: :back,
                          matched_bets: nil
                        }
                    )

                    # insert into database
                    case BetUnfair.Repo.insert(changeset1) do
                      {:ok, bet} -> {:ok, bet}
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

    assert {:ok, 1} = Betunfair.bet_lay("user", 1, 25, 1.5)

  """
  @spec bet_lay(String.t(),
                 number(),
                 number(),
                 number()) :: {:ok, map()}
  def bet_lay(user_id, market_id, stake, odds) do

    # check if user exists
    case BetUnfair.Controllers.User.user_get(user_id) do
      {:ok, user_data} ->
        # check if market exists
        case BetUnfair.Controllers.Market.market_get(market_id) do
          {:ok, _} ->

            # check user balance, if enough, reduce it
            {_, balance} = BetUnfair.Controllers.User.user_get_balance(user_data)

              if balance >= stake do
                # can bet

                # substract money from user
                new_balance = balance - stake
                changeset =
                  BetUnfair.Schemas.User.changeset(
                    user_data,
                    %{
                      wallet_balance: new_balance
                    }
                  )

                case BetUnfair.Repo.update(changeset) do
                  {:ok, _} ->

                    # create bet
                    changeset1 = BetUnfair.Schemas.Bet.changeset(
                      %BetUnfair.Schemas.Bet{},
                        %{
                          username: user_id.username,
                          market_name: market_id.market_name,
                          original_stake: stake,
                          remaining_stake: stake,
                          odds: odds,
                          bet_type: :lay,
                          matched_bets: nil
                        }
                    )

                    # insert into database
                    case BetUnfair.Repo.insert(changeset1) do
                      {:ok, bet} -> {:ok, bet}
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

    assert :ok = Betunfair.bet_cancel(1)

  """
  @spec bet_cancel(map()) :: :ok
  def bet_cancel(bet) do
  # check if bet exists
    ## REMOVED UNTIL BET_GET WORKS
    ##case BetUnfair.Controllers.Bet.bet_get(bet) do
    ##  {:ok, bet} ->
        # change status and remove unmatched stake
        change = BetUnfair.Schemas.Bet.changeset(bet, %{status: :cancelled, remaining_stake: 0})

        case BetUnfair.Repo.update(change) do
          {:ok, _} -> :ok
          {:error, changeset} -> {:error, "Failed to update bet: #{inspect(changeset.errors)}"}
        end

      ##{:error, reason} ->
      ##  {:error, reason}
    ##end
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
                   status: :active}} = Betunfair.bet_get(bet)

  """
  @spec bet_get(map()) :: {:ok, map()}
  def bet_get(bet) do
    case BetUnfair.Repo.get_by(BetUnfair.Schemas.Bet, bet_id: bet.bet_id) do
      nil ->
        {:error, "Bet not found"}

      bet_data ->
        {:ok, bet_data}
    end
  end

end
