defmodule BetUnfair.Schemas.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  alias BetUnfair.Schemas.Bet
  alias BetUnfair.Schemas.Matched_bets

  defmodule BetUnfair.Schemas.Bet.Status do
    @behaviour Ecto.Type

    @type t ::
            :active
            | :cancelled
            | :market_cancelled
            | {:market_settled, boolean()}

    @t [
      :active,
      :cancelled,
      :market_cancelled,
      {:market_settled, true},
      {:market_settled, false}
    ]

    @impl Ecto.Type
    def type, do: :string

    @impl Ecto.Type
    def cast(value) when value in @t, do: {:ok, value}
    def cast(_), do: :error

    @impl Ecto.Type
    def dump(value) when value in @t do
      case is_tuple(value) do
        false -> {:ok, to_string(value)}
        true -> {:ok, to_string(elem(value, 1))}
        end
    end

    def dump(_), do: :error

    @impl Ecto.Type
    def load(value) when is_binary(value) do
      case value do
        "active" -> {:ok, :active}
        "cancelled" -> {:ok, :cancelled}
        "market_cancelled" -> {:ok, :market_cancelled}
        "true" -> {:ok, {:market_settled, true}}
        "false" -> {:ok, {:market_settled, false}}
        _ -> :error
      end
    end

    def load(_), do: :error

    @impl Ecto.Type
    def embed_as(_), do: :string

    @impl Ecto.Type
    def equal?(value1, value2), do: value1 == value2
  end

  @primary_key {:bet_id, :binary_id, autogenerate: true}

  schema "bet" do
    field(:username, :string)
    field(:market_name, :string)
    field(:original_stake, :integer)
    field(:remaining_stake, :integer)
    field(:odds, :integer)
    field(:bet_type, Ecto.Enum, values: [:lay, :back])
    many_to_many  :matched_bets,
                  Bet,
                  join_through: Matched_bets,
                  join_keys: [bet_id: :bet_id, matched_bet_id: :matched_bet_id]
    field(:status, BetUnfair.Schemas.Bet.Status, default: :active)
    timestamps(inserted_at: :inserted_at, updated_at: :updated_at)
  end


  def changeset(bet, params \\ %{}) do
    bet
    |> cast(params, [:bet_id, :username, :market_name, :original_stake, :remaining_stake, :odds, :bet_type, :status])
    |> validate_required([:username, :market_name])
  end
end

  defmodule BetUnfair.Schemas.Matched_bets do
    use Ecto.Schema

    @primary_key {:matched_bet_id, :binary_id, autogenerate: true}

    schema "matched_bets" do
      field :bet_id, :binary_id
      field :matched_amount, :integer
      timestamps(inserted_at: :inserted_at, updated_at: :updated_at)
    end

end
