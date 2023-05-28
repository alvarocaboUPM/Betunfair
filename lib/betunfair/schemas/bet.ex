defmodule BetUnfair.Schemas.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bet" do
    field(:bet_id, :integer, primary_key: true)
    field(:username, :string)
    field(:event_id, :integer)
    field(:amount, :float)
    field(:odds, :float)
    field(:bet_type, :string)
    field(:is_matched, :boolean)
  end

  def changeset(bet, params \\ %{}) do
    bet
    |> cast(params, [:bet_id, :username, :event_id, :amount, :odds, :bet_type, :is_matched])
    |> validate_required([:bet_id])
  end
end
