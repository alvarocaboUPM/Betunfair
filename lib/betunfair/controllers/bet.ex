defmodule BetUnfair.Controllers.Bet do
  import Ecto.Query

  @doc """
  Creates a new backing bet by a user and in a market

  ## Examples

    assert {:ok, 1} = Betunfair.bet_back("user", 1, 25, 1.5)

  """
  @spec bet_back(String.t(),
                 number(),
                 number(),
                 number()) :: {:ok, number()}
  def bet_back(user_id, market_id, stake, odds) do

    # check if user exists
    case BetUnfair.user_get(user_id) do
      {:ok, _} ->
        # check if market exists
        case BetUnfair.market_get(market_id) do
          {:ok, _} ->

            # check user balance, if enough, reduce it
            query = from u in "Users",
                  where: u.username == ^user_id,
                  select: [u.wallet_balance, u.full_name]

            result = BetUnfair.Repo.all(query)

            if result[0] >= stake  do
                # can bet

                # substract money from user
                new_balance = result - stake
                changeset =
                  BetUnfair.Schemas.User.changeset(
                    %BetUnfair.Schemas.User{},
                    %{
                      username: user_id,
                      full_name: result[1],
                      wallet_balance: new_balance
                    }
                  )

                case BetUnfair.Repo.update(changeset) do
                  {:ok, user} ->

                    # create bet
                    bet_id = 0 # generate random number for id TODO
                    changeset = BetUnfair.Schemas.Bet.changeset(
                      user,
                        %{
                          bet_id: bet_id,
                          username: user_id,
                          event_id: market_id,
                          amount: stake,
                          odds: odds,
                          bet_type: "bet_back",
                          is_matched: false
                        }
                    )

                    # insert into database
                    case BetUnfair.Repo.insert(changeset) do
                      {:ok, bet} -> {:ok, bet}
                      {:error, changeset} -> {:error, changeset}
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
                 number()) :: {:ok, number()}
  def bet_lay(user_id, market_id, stake, odds) do

    # check if user exists
    case BetUnfair.Controllers.User.user_get(user_id) do
      {:ok, _} ->
        # check if market exists
        case BetUnfair.market_get(market_id) do
          {:ok, _} ->

            # check user balance, if enough, reduce it
            query = from u in "Users",
                  where: u.username == ^user_id,
                  select: [u.wallet_balance, u.full_name]

            result = BetUnfair.Repo.all(query)

            if result[0] >= stake do
                # can bet

                # substract money from user
                new_balance = result - stake
                changeset =
                  BetUnfair.Schemas.User.changeset(
                    %BetUnfair.Schemas.User{},
                    %{
                      username: user_id,
                      full_name: result[1],
                      wallet_balance: new_balance
                    }
                  )

                case BetUnfair.Repo.update(changeset) do
                  {:ok, user} ->

                    # create bet
                    bet_id = 0 # generate random number for id TODO
                    changeset = BetUnfair.Schemas.Bet.changeset(
                      user,
                        %{
                          bet_id: bet_id,
                          username: user_id,
                          event_id: market_id,
                          amount: stake,
                          odds: odds,
                          bet_type: "bet_lay",
                          is_matched: false
                        }
                    )

                    # insert into database
                    case BetUnfair.Repo.insert(changeset) do
                      {:ok, bet} -> {:ok, bet}
                      {:error, changeset}
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
  @spec bet_cancel(number()) :: :ok
  def bet_cancel(id) do
  # check if bet exists
    # case BetUnfair.Controllers.User.user_get(user_id) do
    #   {:ok, _} ->
    #     # change status and remove unmatched stake
    #     change = BetUnfair.Schemas.Bet.changeset(market, %{status: :cancelled, remaining_amount: 0})

    #     case BetUnfair.Repo.update(change) do
    #       {:ok, m} -> {:ok, m}
    #       {:error, changeset} -> {:error, "Failed to update bet: #{inspect(changeset.errors)}"}
    #     end

    #   {:error, reason} ->
    #     {:error, reason}
    # end
  end

  @doc """
  Gets current information about the state of a bet

  ## Examples

    assert {:ok, %{bet_type: :back,
                   market_id: market,
                   user_id: user,
                   odds: PONER INTEGER,
                   original_stake: PONER INTEGER,
                   remaining_stake: PONER INTEGER,
                   matched_bets: [2, 3],
                   status: :active}} = Betunfair.bet_get(1)

  """
  @spec bet_get(number()) :: {:ok, map()}
  def bet_get(id) do
    # code here
  end

end
