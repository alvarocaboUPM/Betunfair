defmodule BetUnfair.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:username, :string, autogenerate: false}

  schema "user" do
    field :full_name, :string
    field :password, :string
    field :wallet_balance, :float
    timestamps(type: :utc_datetime, inserted_at: :inserted_at, updated_at: :updated_at)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :full_name, :password, :wallet_balance])
    |> validate_required([:username, :full_name])
    |> unique_constraint(:username, name: :user_username_index)
  end
end
