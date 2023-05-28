defmodule BetUnfair.Schemas.Market do
  use Ecto.Schema

  schema "market" do
    field(:market_id, :integer, primary_key: true)
    field(:market_name, :string)
    field(:market_description, :string)
    field(:market_date, :utc_datetime)
    field(:is_settled, :boolean)
    field(:outcome, :string)
  end
end
