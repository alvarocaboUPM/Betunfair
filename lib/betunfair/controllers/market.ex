defmodule BetUnfair.Controllers.Market do
  import Ecto.Query

  @doc """
  Creates a new market with the given name and description.

  ## Examples

      {:ok, m1} = BetUnfair.market_create(:rmw, "Real Madrid wins")

  """
  @spec market_create(atom(), String.t()) :: {:ok, String.t()}
  def market_create(name, description) do
    changeset =
      BetUnfair.Schemas.Market.changeset(
        %BetUnfair.Schemas.Market{},
        %{
          market_name: name,
          market_description: description,
          status: :active
        }
      )

    case BetUnfair.Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end


  def market_get(market) do
    case BetUnfair.Repo.get_by(BetUnfair.Schemas.Market, market_name: market.market_name) do
      nil ->
        {:error, "Market not found"}

      market_data ->
        {:ok, market_data}
    end
  end

  @doc """
  Retrieves a list of all markets.

  ## Examples

      markets = BetUnfair.market_list()

  """
  @spec market_list() :: list()
  def market_list() do
    markets =
      BetUnfair.Schemas.Market
      |> BetUnfair.Repo.all()

    {:ok, markets}
  end

  @doc """
  Retrieves a list of active markets.

  ## Examples

      active_markets = BetUnfair.market_list_active()
      IO.inspect(active_markets)

  """
  @spec market_list_active() :: list()
  def market_list_active() do
    query =
      from(m in BetUnfair.Schemas.Market,
        where: [status: :active],
        select: [:market_name, :market_description, :status]
      )

    markets = BetUnfair.Repo.all(query)
    {:ok, markets}
  end

  @doc """
  Cancels the specified market.

  ## Examples

      :ok = BetUnfair.market_cancel(m1)

  """
  @spec market_cancel(BetUnfair.Schemas.Market) :: :ok | {:error, String.t()}
  def market_cancel(market) when is_map(market) do
    change = BetUnfair.Schemas.Market.changeset(market, %{status: :cancelled})

    case BetUnfair.Repo.update(change) do
      {:ok, m} -> {:ok, m}
      {:error, changeset} -> {:error, "Failed to update market: #{inspect(changeset.errors)}"}
    end
  end

  @doc """
  Freezes the specified market.

  ## Examples

      :ok = BetUnfair.market_freeze(m1)

  """
  @spec market_freeze(BetUnfair.Schemas.Market) :: :ok | {:error, String.t()}
  def market_freeze(market) when is_map(market) do
    change = BetUnfair.Schemas.Market.changeset(market, %{status: :frozen})

    case BetUnfair.Repo.update(change) do
      {:ok, _} -> :ok
      {:error, changeset} -> {:error, "Failed to update market: #{inspect(changeset.errors)}"}
    end
  end

  @doc """
  Sets the result of the specified market.

  ## Examples

      :ok = BetUnfair.market_settle(m1, "Win")

  """
  @spec market_settle(BetUnfair.Schemas.Market, boolean()) :: :ok | {:error, String.t()}
  def market_settle(market, result) when is_boolean(result) do
    changeset = BetUnfair.Schemas.Market.changeset(market, %{status: {:settled, result}})

    case BetUnfair.Repo.update(changeset) do
      {:ok, m} -> {:ok, m}
      {:error, changeset} -> {:error, "Failed to update market: #{inspect(changeset.errors)}"}
    end
  end

 @doc """
Retrieves a list of bets placed on the specified market.

## Examples

    bets = BetUnfair.market_bets(m1.market_name)
    IO.inspect(bets)

"""
@spec market_bets(String.t()) :: list()
def market_bets(id) do
  from(b in BetUnfair.Schemas.Bet, where: b.event_id == ^id, select: b)
  |> BetUnfair.Repo.all()
end


  @doc """
Retrieves a list of pending back bets on the specified market.

## Examples

    pending_backs = BetUnfair.market_pending_backs(m1.market_name)
    IO.inspect(pending_backs)

"""
@spec market_pending_backs(String.t()) :: list()
def market_pending_backs(id) do
  from(b in BetUnfair.Schemas.Bet,
    where: b.market_name == ^id and b.bet_type == "bet_back",
    select: b
  )
  |> BetUnfair.Repo.all()
end


  @doc """
  Retrieves a list of pending lay bets on the specified market.

  ## Examples

      pending_lays = BetUnfair.market_pending_lays(m1.market_name)
      IO.inspect(pending_lays)

  """
  @spec market_pending_lays(String.t()) :: list()
  def market_pending_lays(id) do
    from(b in BetUnfair.Schemas.Bet,
    where: b.market_name == ^id and b.bet_type == "bet_lay",
    select: b
  )
  |> BetUnfair.Repo.all()
  end

@doc """
Matches the pending back and lay bets on the specified market.

## Examples

  :ok = BetUnfair.market_match(m1.market_name)

"""
@spec market_match(String.t()) :: :ok | {:error, String.t()}
def market_match(id) do
  fetch_bets(id) |>
  match_bets()

  :ok
end

defp fetch_bets(id) do
  back_bets =
    from(b in BetUnfair.Schemas.Bet,
      where: b.market_name == ^id and b.bet_type == :back and b.status == :active,
      order_by: [asc: b.odds, desc: b.inserted_at]
    )
    |> BetUnfair.Repo.all()

  lay_bets =
    from(b in BetUnfair.Schemas.Bet,
      where: b.market_name == ^id and b.bet_type == :lay and b.status == :active,
      order_by: [desc: b.odds, desc: b.inserted_at]
    )
    |> BetUnfair.Repo.all()

  {back_bets, lay_bets}
end

#Convertir en funcional
defp match_bets({back_bets, lay_bets}) do
  Enum.each(back_bets, fn back_bet ->
    Enum.each(lay_bets, fn lay_bet ->
      if back_bet.odds <= lay_bet.odds do
        matched_amount = calculate_matched_amount(back_bet, lay_bet)

        update_bet_stakes(back_bet, lay_bet, matched_amount)

        record_matched_bets(back_bet, lay_bet, matched_amount)
      end
    end)
  end)
end

defp calculate_matched_amount(back_bet, lay_bet) do
  if back_bet.remaining_amount * back_bet.odds - back_bet.remaining_amount >= lay_bet.remaining_amount do
    lay_bet.remaining_amount
  else
    back_bet.remaining_amount * back_bet.odds - back_bet.remaining_amount
  end
end

defp update_bet_stakes(back_bet, lay_bet, matched_amount) do
  back_bet = %{back_bet | remaining_amount: back_bet.remaining_amount - matched_amount}
  lay_bet = %{lay_bet | remaining_amount: lay_bet.remaining_amount - matched_amount}

  BetUnfair.Repo.update_all([back_bet, lay_bet])
end

defp record_matched_bets(back_bet, lay_bet, matched_amount) do
  # Code to record matched bets, odds, and matched amounts
end



end
