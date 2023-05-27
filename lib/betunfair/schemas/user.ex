defmodule BetUnfair.Schemas.User do
  use Ecto.Schema

  @primary_key {:username, :string, autogenerate: false}

  schema "user" do
    field :full_name, :string
    field :password, :string
    field :wallet_balance, :float
  end
end
