defmodule WsprHub.Spots.Spot do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  #   0 MF
  #   1 160m
  #   3 80m
  #   5 60m
  #   6 ??
  #   7 40m
  #   8 ??
  #  -1 LF
  #  10 30m
  #  13 ??
  #  14 20m
  #  15 ??
  #  18 17m
  #  21 15m
  #  24 12m
  #  28 10m
  #  50 6m
  #  70 ??
  # 144 2m
  # 145 2m
  # 146 2m
  # 162 ??
  # 432 70cm
  # 1296 23cm
  # 3568 ??
  # 3570 ??
  # 25 ??

  @valid_orders %{
    "spot_dt" => :spot_dt,
    "distance" => :distance
  }

  schema "spots" do
    field :azimuth, :integer
    field :band, :string
    field :callsign, :string
    field :code, :string
    field :distance, :integer
    field :drift, :integer
    field :frequency, :float
    field :grid, :string
    field :power, :integer
    field :reporter, :string
    field :reporter_grid, :string
    field :snr, :integer
    field :spot_dt, :utc_datetime
    field :version, :string
    field :ext_id, :integer

    timestamps()
  end

  def by_timeframe(query), do: by_timeframe(query, :week_ago)
  def by_timeframe(query, :week_ago), do: by_timeframe(query, "week")
  def by_timeframe(query, :month_ago), do: by_timeframe(query, "month")
  def by_timeframe(query, :forever), do: query

  def by_timeframe(query, timeframe) do
    from s in query,
      where: s.spot_dt > datetime_add(^NaiveDateTime.utc_now(), -1, ^timeframe)
  end

  def by_band(query, ""), do: query
  def by_band(query, nil), do: from(s in query, where: is_nil(s.band))
  def by_band(query, band), do: from(s in query, where: s.band == ^band)

  @spec by_callsign(any, any) :: Ecto.Query.t()
  def by_callsign(query, ""), do: query

  def by_callsign(query, callsign) do
    from s in query,
      where: s.callsign == ^callsign
  end

  def by_reporter(query, ""), do: query

  def by_reporter(query, callsign) do
    from s in query,
      where: s.reporter == ^callsign
  end

  def by_distance(query, nil, nil), do: query

  def by_distance(query, min_km, nil) do
    from s in query,
      where: s.distance > ^min_km
  end

  def by_distance(query, nil, max_km) do
    from s in query,
      where: s.distance < ^max_km
  end

  def by_distance(query, min_km, max_km) do
    from s in query,
      where: s.distance < ^max_km and s.distance > ^min_km
  end

  def by_date_range(query, nil, nil), do: query

  def by_date_range(query, start_dt, nil) do
    from s in query,
      where: s.spot_dt >= ^start_dt
  end

  def by_date_range(query, nil, end_dt) do
    from s in query,
      where: s.spot_dt <= ^end_dt
  end

  def by_date_range(query, start_dt, end_dt) do
    from s in query,
      where: s.spot_dt >= ^start_dt and s.spot_dt <= ^end_dt
  end

  def limit(query, nil), do: from(s in query, limit: 50)

  def limit(query, limit) do
    from s in query, limit: ^limit
  end

  def order_by(query, order_by, "asc") do
    order_by_column = Map.get(@valid_orders, order_by, :spot_dt)

    from s in query,
      order_by: [asc: ^order_by_column]
  end

  def order_by(query, order_by, _) do
    order_by_column = Map.get(@valid_orders, order_by, :spot_dt)

    from s in query,
      order_by: [desc: ^order_by_column]
  end

  @doc false
  def changeset(spot, attrs) do
    spot
    |> cast(attrs, [
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
    ])
    |> cast_timestamp([:spot_dt])
    |> validate_required([
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
      :code
    ])
    |> unique_constraint(:ext_id)
  end

  defp cast_timestamp(%Ecto.Changeset{} = changeset, fields) when is_list(fields) do
    Enum.reduce(fields, changeset, fn field, acc -> cast_timestamp(acc, field) end)
  end

  defp cast_timestamp(%Ecto.Changeset{} = changeset, field) when is_atom(field) do
    with field_timestamp when not is_nil(field_timestamp) <-
           Map.get(changeset.params, to_string(field)),
         {unix_timestamp, ""} <- Integer.parse(field_timestamp),
         {:ok, datetime} <- DateTime.from_unix(unix_timestamp) do
      put_change(changeset, field, datetime)
    else
      {:error, reason} -> add_error(changeset, field, reason)
      _ -> add_error(changeset, field, "Unable to process timestamp")
    end
  end
end
