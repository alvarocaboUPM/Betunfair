defmodule BetUnfair.Controllers.User do
  @doc """
  Creates a new user with the given username and full name.

  ## Examples

      assert {:ok, user} = BetUnfair.user_create("u1", "Francisco Gonzalez")

  """
  @spec user_create(String.t(), String.t()) :: {:ok, map()}
  def user_create(username, full_name) do
    changeset =
      BetUnfair.Schemas.User.changeset(
        %BetUnfair.Schemas.User{},
        %{
          username: username,
          full_name: full_name,
          password: nil,
          wallet_balance: 0.0
        }
      )


    case BetUnfair.Repo.insert(changeset) do
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
  def user_deposit(user, amount) when is_map(user) and is_number(amount) do
    # Validate the user and amount
    case user_get(user) do
      {:ok, user_data} ->
        if amount > 0 do
          new_balance = user_data.wallet_balance + amount
          changeset = BetUnfair.Schemas.User.changeset(user_data, %{wallet_balance: new_balance})
          case BetUnfair.Repo.update(changeset) do
            {:ok, user} -> {:ok, user}
            {:error, changeset} -> {:error, changeset}
          end
        else
          {:error, "Invalid amount"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def user_deposit(_user, _amount), do: {:error, "Invalid arguments"}

  @doc """
  Removes the given amount from the user's account.

  ## Examples

      assert :ok = BetUnfair.user_withdraw(user, 2000)

  """
  @spec user_withdraw(map(), number()) :: :ok | {:error, String.t()}
  def user_withdraw(user, amount) when is_map(user) and is_number(amount) do
    case user_get_balance(user) do
      {:ok, balance} ->
        case validate_withdrawal(balance, amount) do
          :ok ->
            new_balance = balance - (amount / 1)
            changeset = BetUnfair.Schemas.User.changeset(user, %{wallet_balance: new_balance})
          case BetUnfair.Repo.update(changeset) do
            {:ok, user} -> {:ok, user}
            {:error, changeset} -> {:error, changeset}
          end

          {:error, error} ->
            {:error, error}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def user_withdraw(_user, _amount), do: {:error, "Invalid arguments"}

  defp validate_withdrawal(balance, amount) do
    cond do
      amount <= 0 ->
        {:error, "Invalid amount"}

      amount > balance ->
        {:error, "Insufficient balance"}

      true ->
        :ok
    end
  end

  @doc """
  Retrieves the user's data.

  ## Examples

    {:ok, u1} = BetUnfair.user_get(user)
    u1
    %{username: "u1", full_name: "Francisco F", password: nil, balance: 2000}

  """
  @spec user_get(map()) :: {:ok, map()}
  def user_get(user) do
    case BetUnfair.Repo.get_by(BetUnfair.Schemas.User, username: user.username) do
      nil ->
        {:error, "User not found"}

      user_data ->
        {:ok, user_data}
    end
  end


  @doc """
  Returns an enumerable containing all bets of the user

  ## Examples

  """
  @spec user_bets(BetUnfair.Schemas.User):: Enumerable.t(BetUnfair.Schemas.Bet)
  def user_bets(user) do
    {:ok, user}
  end

  @spec user_get_balance(BetUnfair.Schemas.User) :: float()
  def user_get_balance(user) do
    case user_get(user) do
    {:ok, %BetUnfair.Schemas.User{ wallet_balance: wallet_balance}} ->
        {:ok, wallet_balance}
    _ ->
        {:error, "User not found"}
    end
  end
end
