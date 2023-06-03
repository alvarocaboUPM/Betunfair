defmodule BetUnfair.Controllers.User do
  import Ecto.Query

  @type user_id() :: String.t()

  @doc """
  Creates a new user with the given username and full name.

  ## Examples

      assert {:ok, user} = BetUnfair.user_create("u1", "Francisco Gonzalez")

  """
  @spec user_create(String.t(), String.t()) :: {:ok, user_id()}
  def user_create(username, full_name) do
    changeset =
      BetUnfair.Schemas.User.changeset(
        %BetUnfair.Schemas.User{},
        %{
          username: username,
          full_name: full_name,
          password: nil,
          balance: 0
        }
      )

    case BetUnfair.Repo.insert(changeset) do
      {:ok, user} -> {:ok, user.user_id}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Deposits the given amount into the user's account.

  ## Examples

      assert :ok = BetUnfair.user_deposit(user, 2000)

  """
  @spec user_deposit(user_id(), number()) :: :ok | {:error, String.t()}
  def user_deposit(id, amount) when is_number(amount) do
    balance_operation(id, amount, :deposit)
  end

  @doc """
  Removes the given amount from the user's account.

  ## Examples

      assert :ok = BetUnfair.user_withdraw(user, 2000)

  """
  @spec user_withdraw(user_id(), number()) :: :ok | {:error, String.t()}
  def user_withdraw(id, amount) when is_number(amount) do
    balance_operation(id, amount, :withdraw)
  end

  defp balance_operation(id, amount, operation) do
    # Validate the user and amount
    case user_get(id) do
      {:ok, user_data} ->
        if amount > 0 do
          case n_balance(amount, user_data.balance, operation) do
            {:ok, new_balance} ->
              changeset = BetUnfair.Schemas.User.changeset(user_data, %{balance: new_balance})

              case BetUnfair.Repo.update(changeset) do
                {:ok, _} -> :ok
                {:error, changeset} -> {:error, changeset}
              end

            {:error, err} ->
              {:error, err}
          end
        else
          {:error, "Invalid amount"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp n_balance(amount, balance, :deposit), do: {:ok, balance + amount}
  defp n_balance(amount, balance, :withdraw), do: validate_withdrawal(balance, amount)

  defp validate_withdrawal(balance, amount) do
    cond do
      amount <= 0 ->
        {:error, "Invalid amount"}

      amount > balance ->
        {:error, "Insufficient balance"}

      true ->
        {:ok, balance - amount}
    end
  end

  @doc """
  Retrieves the user's data.

  ## Examples

    {:ok, u1} = BetUnfair.user_get(user)
    u1
    %{username: "u1", full_name: "Francisco F", password: nil, balance: 2000}

  """
  @spec user_get(user_id()) :: {:ok, map()}
  def user_get(id) when is_bitstring(id) do
    case Ecto.UUID.cast(id) do
      {:ok, binary_id} ->
        case BetUnfair.Repo.get_by(BetUnfair.Schemas.User, user_id: binary_id) do
          nil ->
            {:error, "User not found"}

          user_data ->
            {:ok, user_data}
        end

      :error ->
        {:error, "Invalid user ID format"}
    end
  end

  @doc """
  Returns an enumerable containing all bets of the user

  ## Examples

  """
  @spec user_bets(user_id()) :: Enumerable.t(BetUnfair.Schemas.Bet)
  def user_bets(id) do
    case user_get(id) do
      {:ok, user} ->
        r =
          from(b in BetUnfair.Schemas.Bet, where: b.username == ^user.username, select: b)
          |> BetUnfair.Repo.all()
          |> Enum.to_list()

        {:ok, r}

      {:error, err} ->
        {:error, err}
    end
  end

  @spec user_get_balance(user_id()) :: integer()
  def user_get_balance(id) do
    case user_get(id) do
      {:ok, %BetUnfair.Schemas.User{balance: balance}} ->
        {:ok, balance}

      _ ->
        {:error, "User not found"}
    end
  end

  def get_user_id_from_username(username) do
    case BetUnfair.Repo.get_by(BetUnfair.Schemas.User, username: username) do
      nil ->
        {:error, "User not found"}

      user_data ->
        {:ok, user_data.user_id}
    end
  end
end
