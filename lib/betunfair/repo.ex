defmodule BetUnfair.Repo do
  use Ecto.Repo,
    otp_app: :betunfair,
    adapter: Ecto.Adapters.MyXQL

  @doc """

    Tests connection with the database
    
  """
  def ping() do
    case Ecto.Adapters.SQL.query(__MODULE__, "SELECT 1") do
      {:ok, _} -> {:ok, "Database connection is successful"}
      {:error, _} -> {:error, "Unable to establish database connection"}
    end
  end
end
