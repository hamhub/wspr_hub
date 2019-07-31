defmodule WsprHub.SpotsTest do
  use WsprHub.DataCase

  import WsprHub.Factory
  alias WsprHub.Spots
  alias WsprHub.Spots.Spot

  describe "spots" do
    @valid_attrs %{
      azimuth: 42,
      band: "20m",
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
      spot_dt: "1271512800",
      version: "some version"
    }
    @update_attrs %{
      azimuth: 43,
      band: "40m",
      callsign: "some updated callsign",
      code: "some updated code",
      distance: 43,
      drift: 43,
      frequency: 456.7,
      grid: "some updated grid",
      power: 43,
      reporter: "some updated reporter",
      reporter_grid: "some updated reporter_grid",
      snr: 43,
      spot_dt: "1305730861",
      version: "some updated version"
    }
    @invalid_attrs %{
      azimuth: nil,
      band: nil,
      callsign: nil,
      code: nil,
      distance: nil,
      drift: nil,
      frequency: nil,
      grid: nil,
      power: nil,
      reporter: nil,
      reporter_grid: nil,
      snr: nil,
      spot_dt: nil,
      version: nil
    }

    def spot_fixture(attrs \\ %{}) do
      {:ok, spot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Spots.create_spot()

      spot
    end

    test "list_spots/0 returns all spots" do
      spot = spot_fixture()
      assert Spots.list_spots() == [spot]
    end

    test "get_spot!/1 returns the spot with given id" do
      spot = spot_fixture()
      assert Spots.get_spot!(spot.id) == spot
    end

    test "create_spot/1 with valid data creates a spot" do
      assert {:ok, %Spot{} = spot} = Spots.create_spot(@valid_attrs)
      assert spot.azimuth == 42
      assert spot.band == "20m"
      assert spot.callsign == "some callsign"
      assert spot.code == "some code"
      assert spot.distance == 42
      assert spot.drift == 42
      assert spot.frequency == 120.5
      assert spot.grid == "some grid"
      assert spot.power == 42
      assert spot.reporter == "some reporter"
      assert spot.reporter_grid == "some reporter_grid"
      assert spot.snr == 42
      assert spot.spot_dt == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert spot.version == "some version"
    end

    test "create_spot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spots.create_spot(@invalid_attrs)
    end

    test "update_spot/2 with valid data updates the spot" do
      spot = spot_fixture()
      assert {:ok, %Spot{} = spot} = Spots.update_spot(spot, @update_attrs)
      assert spot.azimuth == 43
      assert spot.band == "40m"
      assert spot.callsign == "some updated callsign"
      assert spot.code == "some updated code"
      assert spot.distance == 43
      assert spot.drift == 43
      assert spot.frequency == 456.7
      assert spot.grid == "some updated grid"
      assert spot.power == 43
      assert spot.reporter == "some updated reporter"
      assert spot.reporter_grid == "some updated reporter_grid"
      assert spot.snr == 43
      assert spot.spot_dt == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert spot.version == "some updated version"
    end

    test "update_spot/2 with invalid data returns error changeset" do
      spot = spot_fixture()
      assert {:error, %Ecto.Changeset{}} = Spots.update_spot(spot, @invalid_attrs)
      assert spot == Spots.get_spot!(spot.id)
    end

    test "delete_spot/1 deletes the spot" do
      spot = spot_fixture()
      assert {:ok, %Spot{}} = Spots.delete_spot(spot)
      assert_raise Ecto.NoResultsError, fn -> Spots.get_spot!(spot.id) end
    end

    test "change_spot/1 returns a spot changeset" do
      spot = spot_fixture()
      assert %Ecto.Changeset{} = Spots.change_spot(spot)
    end

    test "search_spots/1 by callsign" do
      spot1 = insert(:spot)
      insert(:spot)

      results = Spots.search_spots(%{callsign: spot1.callsign})

      first_result = hd(results)
      assert first_result.id == spot1.id
      assert Enum.count(results) == 1
    end
  end
end
