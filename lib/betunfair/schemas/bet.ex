defmodule BetUnfair.Schemas.Bet do
  use Ecto.Schema

  schema "bet" do
    field(:bet_id, :integer, primary_key: true)
    field(:user_id, :integer)
    field(:event_id, :integer)
    field(:amount, :float)
    field(:odds, :float)
    field(:bet_type, :string)
    field(:is_matched, :boolean)
  end
end
