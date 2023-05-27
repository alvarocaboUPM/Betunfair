defmodule BetUnfair.Controllers.User do
  @doc """
  Creates a new user with the given username and full name.

  ## Examples

      assert {:ok, user} = BetUnfair.user_create("u1", "Francisco Gonzalez")

  """
  @spec user_create(String.t(), String.t()) :: {:ok, map()}
  def user_create(username, full_name) do
    changeset =
      %BetUnfair.Schemas.User{}
      |> Ecto.Changeset.cast(
        %{
          username: username,
          full_name: full_name,
          password: nil,
          wallet_balance: 0.0
        },
        [:username, :full_name, :password, :wallet_balance]
      )
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
  def user_deposit(user, amount) do
    # Validate the user and amount
    case user_get(user) do
      {:ok, _} ->
        if amount >= 0 do
          # Perform the withdrawal operation
          updated_user = Map.update!(user, :balance, fn balance -> balance - amount end)
          {:ok, updated_user}
        else
          {:error, "Invalid amount"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Removes the given amount from the user's account.

  ## Examples

      assert :ok = BetUnfair.user_withdraw(user, 2000)

  """
  @spec user_withdraw(map(), number()) :: :ok | {:error, String.t()}
  def user_withdraw(user, amount) when is_map(user) and is_number(amount) do
    case user_get(user) do
      {:ok, balance} ->
        case validate_withdrawal(balance, amount) do
          :ok ->
            updated_user = Map.update!(user, :balance, &(&1 - amount))
            {:ok, updated_user}

          {:error, error} ->
            {:error, error}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp validate_withdrawal(balance, amount) do
    cond do
      amount < 0 ->
        {:error, "Invalid amount"}

      amount > balance ->
        {:error, "Insufficient balance"}

      true ->
        :ok
    end
  end

  @doc """
  Retrieves the user's balance.

  ## Examples

      assert {:ok, %{balance: 2000}} = BetUnfair.user_get(user)

  """
  @spec user_get(map()) :: {:ok, map()}
  def user_get(user) do
    case BetUnfair.Repo.get_by(BetUnfair.User, user_id: user[:user_id]) do
      nil ->
        {:error, "User not found"}

      %BetUnfair.Schemas.User{wallet_balance: wallet_balance} ->
        {:ok, wallet_balance}
    end
  end
end
