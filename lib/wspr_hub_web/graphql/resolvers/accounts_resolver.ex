defmodule WsprHubWeb.Resolvers.AccountsResolver do
  alias WsprHub.Accounts
  alias WsprHubWeb.Resolvers

  def create_user(_root, args, _info) do
    args
    |> Accounts.create_user()
    |> case do
      {:error, cs} -> {:error, Resolvers.extract_error_msg(cs)}
      {:ok, user} -> {:ok, user}
    end
  end

  def register_user(_root, args, _info) do
    args
    |> Accounts.register_user()
    |> case do
      {:error, cs} -> {:error, Resolvers.extract_error_msg(cs)}
      {:ok, user} -> {:ok, user}
    end
  end
end
