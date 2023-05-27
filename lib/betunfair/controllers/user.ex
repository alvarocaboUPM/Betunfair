defmodule BetUnfair.Controllers.User do

@doc """
Creates a new user with the given username and full name.

## Examples

    assert {:ok, user} = BetUnfair.user_create("u1", "Francisco Gonzalez")

"""
@spec user_create(String.t(), String.t()) :: {:ok, map()}
def user_create(username, full_name) do
  changeset = %BetUnfair.Schemas.User{}
    |> Ecto.Changeset.cast(%{
      username: username,
      full_name: full_name,
      password: nil,
      wallet_balance: 0.0,
    }, [:username,:full_name, :password, :wallet_balance])
    |> BetUnfair.Repo.insert()

  case changeset do
    {:ok, user} -> {:ok, user}
    {:error, changeset} -> {:error, changeset}
  end
end


  @doc """
  Deposits the given amount into the user's account.

  ## Examples

      assert :ok = BetUnfair.user_deposit(user, 2000)

  """
  @spec user_deposit(map(), number()) :: :ok
  def user_deposit(id, amount) do
    # code here
  end

  @doc """
  Removes the given amount into the user's account.

  ## Examples

      assert :ok = BetUnfair.user_withdraw(user, 2000)

  """
  @spec user_withdraw(map(), number()) :: :ok
  def user_withdraw(id, amount) do
    # code here
  end

  @doc """
  Retrieves the user's balance.

  ## Examples

      assert {:ok, %{balance: 2000}} = BetUnfair.user_get(user)

  """
  @spec user_get(map()) :: {:ok, map()}
  def user_get(id) do
    # code here
  end

end
