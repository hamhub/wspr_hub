defmodule WsprHubWeb.Resolvers.SpotResolver do
  alias WsprHub.Spots

  def list_spots(_root, _args, _info) do
    spots = Spots.list_spots(:month_ago)

    {:ok, spots}
  end

  def search_spots(_root, args, _info) do
    args
    |> Spots.search_spots()
    |> (&{:ok, &1}).()
  end
end
