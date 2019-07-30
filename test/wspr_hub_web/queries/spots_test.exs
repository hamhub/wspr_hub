defmodule WsprHubWeb.Queries.SpotsTest do
  use WsprHubWeb.ConnCase
  alias WsprHubWeb.Schema
  alias WsprHub.Spots

  @valid_attrs %{
    azimuth: 42,
    band: 42,
    callsign: "some callsign",
    code: "some code",
    distance: 42,
    drift: 42,
    frequency: 120.5,
    grid: "some grid",
    power: 42,
    reporter: "some reporter",
    reporter_grid: "some reporter_grid",
    snr: 42,
    spot_dt: DateTime.utc_now() |> DateTime.to_unix() |> to_string(),
    version: "some version"
  }

  test "getting a list of spots" do
    # Insert a spot.
    {:ok, spot} = Spots.create_spot(@valid_attrs)

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
