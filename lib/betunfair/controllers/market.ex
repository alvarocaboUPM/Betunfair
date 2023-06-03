defmodule BetUnfair.Controllers.Market do
  alias ExGram.Model.InputTextMessageContent
  import Ecto.Query

  @type market_id() :: String.t()

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
      {:ok, market} -> {:ok, market.market_id}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Fetches a market from its ID

  ## Examples

      {:ok, m1} = BetUnfair.market_create(:rmw, "Real Madrid wins")

  """
  @spec market_get(id :: market_id()) ::
          {:ok,
           %{
             name: string(),
             description: string(),
             status: :active | :frozen | :cancelled | {:settled, result :: bool()}
           }}
  def market_get(id) do
    case BetUnfair.Repo.get_by(BetUnfair.Schemas.Market, market_id: id) do
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
  Freezes the specified market.

  ## Examples

      :ok = BetUnfair.market_cancel(m1)

  """
  @spec market_freeze(id :: market_id()) :: :ok | {:error, String.t()}
  def market_freeze(id) do
    {_, back_bets} = market_pending_backs(id) |> Enum.to_list() |> Enum.map(fn (e) -> elem(e,1) end)
    {_, lay_bets} = market_pending_lays(id) |> Enum.to_list() |> Enum.map(fn (e) -> elem(e,1) end)
    Enum.concat(back_bets, lay_bets)
    #Returns money to all the unmatched bets
    |>return_money()
    market_set_status(id, :frozen)
  end


  @doc """
  Cancels the specified market.

  ## Examples

      :ok = BetUnfair.market_cancel(m1)

  """
  @spec market_cancel(id :: market_id()) :: :ok | {:error, String.t()}
  def market_cancel(id) do
    #Returns money to all the beters
    market_bets(id)
    |>return_money()

    market_set_status(id, :cancelled)
  end

  defp return_money([]), do: :ok

  defp return_money([h| bets_list]) do
    {_,u_id} = BetUnfair.Controllers.User.get_user_id_from_username(h.username)
    BetUnfair.Controllers.User.user_deposit(u_id, h.remaining_stake)
    IO.puts("Returned " <> Integer.to_string(h.remaining_stake) <> "€ to user: " <> h.username)
    return_money(bets_list)
  end

  @doc """
  Sets the result of the specified  id.

  ## Examples

      :ok = BetUnfair.market_settle(m1)

  """
  @spec market_settle(BetUnfair.Schemas.Market, boolean()) :: :ok | {:error, String.t()}
  def market_settle(id, result) when is_boolean(result) do
    market_set_status(id, {:settled, result})
  end

  defp market_set_status(id, option) do
    case market_get(id) do
      {:ok, market} ->
        change = BetUnfair.Schemas.Market.changeset(market, %{status: option})

        case BetUnfair.Repo.update(change) do
          {:ok, m} -> {:ok, m}
          {:error, changeset} -> {:error, "Failed to update  id: #{inspect(changeset.errors)}"}
        end

      {:error, err} ->
        {:error, err}
    end
  end

  @doc """
  Retrieves a list of bets placed on the specified  id.

  ## Examples

      bets = BetUnfair.market_bets(m1.market_name)

  """
  @spec market_bets(id :: market_id()) :: list() | {:error, String.t()}
  def market_bets(id) do
    case market_get(id) do
      {:ok, market} ->
        from(b in BetUnfair.Schemas.Bet, where: b.market_name == ^market.market_name, select: b)
        |> BetUnfair.Repo.all()

      {:error, err} ->
        {:error, err}
    end
  end

  @doc """
  Retrieves a list of pending back bets on the specified  id.

  ## Examples


  """
  @spec market_pending_backs(id :: market_id()) :: list() | {:error, String.t()}
  def market_pending_backs(id), do: market_pending_bets(id, :back, "desc")

  @doc """
  Retrieves a list of pending lay bets on the specified  id.

  ## Examples

  """
  @spec market_pending_lays(id :: market_id()) :: list() | {:error, String.t()}
  def market_pending_lays(id), do: market_pending_bets(id, :lay, "asc")

  defp market_pending_bets(id, option, order) do
    case market_get(id) do
      {:ok, market} ->
        from(b in BetUnfair.Schemas.Bet,
          where:
            b.market_name == ^market.market_name and b.bet_type == ^option and b.status == :active,
          order_by: ^generate_order_by(order)
        )
        |> BetUnfair.Repo.all()
        |> list_to_tuple([])

      {:error, err} ->
        {:error, err}
    end
  end

  defp list_to_tuple([], res), do: {:ok, res}

  defp list_to_tuple([h | t], res) do
    list_to_tuple(t, [{h.odds, h.id} | res])
  end

  defp generate_order_by("asc"), do: [asc: :odds]
  defp generate_order_by("desc"), do: [desc: :odds]
  defp generate_order_by(_), do: []

  @doc """
  Matches the pending back and lay bets on the specified  id.

  ## Examples

    :ok = BetUnfair.market_match(m1.market_name)

  """
  @spec market_match(id :: market_id()) :: :ok | {:error, String.t()}
  def market_match(id) do
    {_, back_bets} = market_pending_backs(id)
    {_, lay_bets} = market_pending_lays(id)

    # IO.puts("Original back bets: ")
    # IO.inspect(back_bets)
    # IO.puts("Original lay bets: ")
    # IO.inspect(lay_bets)
    match_bets(back_bets, lay_bets)
  end

  defp match_bets([], _), do: :ok

  defp match_bets([bb_tuple | t], lb_tuples) do
    bb_tuples = [bb_tuple | t]

    Enum.each(lb_tuples, fn lb_tuple ->
      # Find potential match: back_odds <= lay_odds
      if elem(bb_tuple, 0) <= elem(lb_tuple, 0) do
        # Get bet objets
        {_, back_bet} = BetUnfair.Controllers.Bet.bet_get(elem(bb_tuple, 1))
        {_, lay_bet} = BetUnfair.Controllers.Bet.bet_get(elem(lb_tuple, 1))
        # Find matching amount
        {b, l} =
          calculate_matched_amount(back_bet, lay_bet)
          # Update the DB
          |> update_bet_stakes(back_bet, lay_bet)
          # Update the queues
          |> new_records(bb_tuples, lb_tuples)

        match_bets(b, l)
      end
    end)

    # Remove lay_bet from queue
    match_bets(t, lb_tuples)
  end

  defp calculate_matched_amount(back_bet, lay_bet) do
    # IO.puts("Matching: " <> back_bet.username <> " and " <> lay_bet.username)
    # Caso 1: Consume todo el back
    if(back_bet.stake * (back_bet.odds / 100) - back_bet.stake <= lay_bet.stake) do
      back_bet.stake
    else
      calculate_matched_amount_aux(back_bet.stake, back_bet.odds, lay_bet.stake)
    end
  end

  # Caso 3: Se consumen mutuamente
  defp calculate_matched_amount_aux(1, _odds, lb_stake), do: lb_stake

  # Caso 2: Consume todo el lay
  defp calculate_matched_amount_aux(i, odds, lb_stake) do
    amount = i * (odds / 100) - i

    if(amount < lb_stake) do
      i+1
    else
      # IO.puts(Integer.to_string(i) <> "-> " <> Float.to_string(amount) <> " > " <> Integer.to_string(lb_stake))
      calculate_matched_amount_aux(i - 1, odds, lb_stake)
    end
  end

  defp update_bet_stakes(matched_amount, back_bet, lay_bet) do
    # IO.puts("Matching amount -> " <> Integer.to_string(matched_amount))

    amount =
      cond do
        back_bet.stake == matched_amount ->
          round(back_bet.stake * (back_bet.odds / 100) - back_bet.stake)
        true ->
          matched_amount
      end

    b_changeset =
      BetUnfair.Schemas.Bet.changeset(back_bet, %{
        stake: back_bet.stake - matched_amount,
        matched_bets: [back_bet.matched_bets | lay_bet]
      })

    l_changeset =
      BetUnfair.Schemas.Bet.changeset(lay_bet, %{
        stake: max(lay_bet.stake - amount, 0),
        matched_bets: [lay_bet.matched_bets | back_bet]
      })

    {_, c1} = BetUnfair.Repo.update(b_changeset)
    {_, c2} = BetUnfair.Repo.update(l_changeset)

    {c1, c2}
  end

  defp new_records({new_bb, new_lb}, [h1 | t1], [h2 | t2]) do
    # 1. BB -> If it's matched, remove it
    bb_tuples =
      if new_bb.stake == 0 do
        # IO.inspect(t1)
        t1
      else
        # IO.puts("Keeping this bb: ")
        # IO.inspect(BetUnfair.Controllers.Bet.bet_get(elem(h1, 1)))
        [h1 | t1]
      end

    # 2. LB -> If it's matched, remove it
    lb_tuples =
      if new_lb.stake == 0 do
        # IO.inspect(t2)
        t2
      else
        # IO.puts("Keeping this lb: ")
        # IO.inspect(BetUnfair.Controllers.Bet.bet_get(elem(h2, 1)))
        [h2 | t2]
      end

    {bb_tuples, lb_tuples}
  end
end
