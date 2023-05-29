defmodule BetUnfair.Controllers.Market do
  import Ecto.Query

  @doc """
  Creates a new market with the given name and description.

  ## Examples

      {:ok, m1} = BetUnfair.market_create(:rmw, "Real Madrid wins")

  """
  @spec market_create(atom(), String.t()) :: {:ok, map()}
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
  @spec market_cancel(map()) :: :ok | {:error, String.t()}
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
  @spec market_freeze(map()) :: :ok | {:error, String.t()}
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
  @spec market_settle(map(), boolean()) :: :ok | {:error, String.t()}
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

    bets = BetUnfair.market_bets(m1)
    IO.inspect(bets)

"""
@spec market_bets(map()) :: list()
def market_bets(id) do
  from(b in BetUnfair.Schemas.Bet, where: b.event_id == ^id, select: b)
  |> BetUnfair.Repo.all()
end


  @doc """
  Retrieves a list of pending back bets on the specified market.

  ## Examples

      pending_backs = BetUnfair.market_pending_backs(m1)
      IO.inspect(pending_backs)

  """
  @spec market_pending_backs(map()) :: list()
  def market_pending_backs(id) do
    # Retrieves a list of pending back bets on the specified market.
  end

  @doc """
  Retrieves a list of pending lay bets on the specified market.

  ## Examples

      pending_lays = BetUnfair.market_pending_lays(m1)
      IO.inspect(pending_lays)

  """
  @spec market_pending_lays(map()) :: list()
  def market_pending_lays(id) do
    # Retrieves a list of pending lay bets on the specified market.
  end

  @doc """
  Matches the pending back and lay bets on the specified market.

  ## Examples

    :ok = BetUnfair.market_match(m1)


  """
  @spec market_match(map) :: :ok | {:error, String.t()}
  def market_match(id) do
    # code here
  end


end
