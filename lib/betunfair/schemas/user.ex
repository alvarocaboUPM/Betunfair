defmodule BetUnfair.Schemas.User do
  use Ecto.Schema

  schema "user" do
    field :username, :string
    field :full_name, :string
    field :password, :string
    field :wallet_balance, :float
  end
end
