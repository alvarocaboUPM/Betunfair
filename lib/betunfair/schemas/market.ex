defmodule BetUnfair.Schemas.Market do
  use Ecto.Schema

  schema "market" do
    field(:event_id, :integer)
    field(:event_name, :string)
    field(:event_description, :string)
    field(:event_date, :utc_datetime)
    field(:is_settled, :boolean)
    field(:outcome, :string)
  end
end
