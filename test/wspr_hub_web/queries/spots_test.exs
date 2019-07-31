defmodule WsprHubWeb.Queries.SpotsTest do
  use WsprHubWeb.ConnCase
  import WsprHub.Factory

  alias WsprHubWeb.Schema
  alias WsprHub.Spots

  test "getting a list of spots" do
    spot = insert(:spot)

    # define the query
    query = """
    {
      allSpots {
        id
        callsign
      }
    }
    """

    context = %{}

    {:ok, %{data: %{"allSpots" => spots}}} = Absinthe.run(query, Schema, context: context)
    first_spot = hd(spots)
    assert first_spot["id"] == to_string(spot.id)
    assert first_spot["callsign"] == spot.callsign
  end
end
