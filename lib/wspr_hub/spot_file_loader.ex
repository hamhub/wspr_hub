defmodule WsprHub.SpotFileLoader do
  alias WsprHub.Repo
  alias WsprHub.Spots.Spot

  def test_load do
    load_file("wspr_csv/wsprspots-2019-07.csv")
  end

  def load_file(filename) do
    filename
    |> Path.expand(File.cwd!())
    |> File.stream!()
    |> CSV.decode(
      headers: [
        :ext_id,
        :spot_dt,
        :reporter,
        :reporter_grid,
        :snr,
        :frequency,
        :callsign,
        :grid,
        :power,
        :drift,
        :distance,
        :azimuth,
        :band,
        :version,
        :code
      ]
    )
    |> Stream.reject(fn
      {:ok, _map} -> false
      {:error, _reason} -> true
    end)
    |> Stream.map(fn {:ok, map} -> map end)
    |> Stream.chunk_every(3_000)
    |> Task.async_stream(&process_spot_chunk/1, max_concurrency: 4, timeout: 360_000)
    |> Stream.run()
  end

  defp process_spot_chunk(chunk) do
    spot_chunks =
      chunk
      |> Enum.map(&process_spot/1)

    Repo.insert_all(Spot, spot_chunks, on_conflict: :nothing)
  end

  def process_spot(spot_row) do
    now =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_naive()

    spot_row
    |> cast_integer_fields([:azimuth, :distance, :drift, :power, :snr, :ext_id])
    |> cast_float_fields([:frequency])
    |> cast_band()
    |> Map.update(:spot_dt, "0", fn spot_dt ->
      with {ts, ""} <- Integer.parse(spot_dt),
           {:ok, dt} <- DateTime.from_unix(ts) do
        dt
      end
    end)
    |> Map.put(:inserted_at, now)
    |> Map.put(:updated_at, now)
  end

  defp cast_band(spot_row) do
    band = HamRadio.Band.at(spot_row.frequency * 1_000_000)

    if is_nil(band) do
      Map.put(spot_row, :band, "Unknown band")
    else
      Map.put(spot_row, :band, band.name)
    end
  end

  defp cast_integer_fields(spot_row, []), do: spot_row

  defp cast_integer_fields(spot_row, [field | fields]) do
    spot_row
    |> Map.update(field, "0", &String.to_integer(&1))
    |> cast_integer_fields(fields)
  end

  defp cast_float_fields(spot_row, []), do: spot_row

  defp cast_float_fields(spot_row, [field | fields]) do
    spot_row
    |> Map.update(field, "0", &String.to_float(&1))
    |> cast_float_fields(fields)
  end
end
