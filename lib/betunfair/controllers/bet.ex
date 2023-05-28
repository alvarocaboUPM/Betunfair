defmodule BetUnfair.Controllers.Bet do

  @doc """
  Creates a new backing bet by a user and in a market

  ## Examples

    assert {:ok, 1} = Betunfair.bet_back("user", 1, 25, 1.5)

  """
  @spec bet_back(String.t(),
                 market_id(),
                 number(),
                 number()) :: {:ok, number()}
  def bet_back(user_id, market_id, stake, odds) do
    # code here
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
    # code here
  end

  @doc """
  Cancels the parts of a bet that have not been matched

  ## Examples

    assert :ok = Betunfair.bet_cancel(1)

  """
  @spec bet_cancel(number()) :: :ok
  def bet_cancel(id) do
    # code here
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
