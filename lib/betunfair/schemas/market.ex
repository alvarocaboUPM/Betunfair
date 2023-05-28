defmodule BetUnfair.Schemas.Market do
  use Ecto.Schema
  import Ecto.Changeset

  defmodule BetUnfair.Schemas.Market.Status do
    @behaviour Ecto.Type

    @type t ::
            :active
            | :frozen
            | :cancelled
            | {:settled, boolean()}

    @t [
      :active,
      :frozen,
      :cancelled,
      {:settled, true},
      {:settled, false}
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
        "frozen" -> {:ok, :frozen}
        "cancelled" -> {:ok, :cancelled}
        "true" -> {:ok, {:settled, true}}
        "false" -> {:ok, {:settled, false}}
        _ -> :error
      end
    end

    def load(_), do: :error

    @impl Ecto.Type
    def embed_as(_), do: :string

    @impl Ecto.Type
    def equal?(value1, value2), do: value1 == value2
  end

  @primary_key {:market_name, :string, autogenerate: false}


  schema "market" do
    field(:market_description, :string)
    field(:status, BetUnfair.Schemas.Market.Status, default: :active)
    timestamps(type: :utc_datetime, inserted_at: :inserted_at, updated_at: :updated_at)
  end

  def changeset(market, params \\ %{}) do
    market
    |> cast(params, [:market_name, :market_description, :status])
    |> validate_required([:market_name, :market_description])
    |> unique_constraint(:market_name, name: :market_market_name_index)
  end
end
