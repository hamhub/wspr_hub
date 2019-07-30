defmodule WsprHubWeb.Schema.SpotTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: WsprHub.Repo

  alias WsprHubWeb.Resolvers.SpotResolver

  # Object definitions
  object :spot do
    field :id, non_null(:id)
    field :spot_dt, non_null(:datetime)
    @desc "The callsign of the station that was seen"
    field :callsign, non_null(:string)
    field :frequency, non_null(:string)
    field :band, non_null(:string)
    @desc "Signal to Noise Ratio"
    field :snr, non_null(:integer)
    field :drift, non_null(:string)
    @desc "The grid location of the station that was seen"
    field :grid, non_null(:string)
    @desc "Power in dBm"
    field :power, non_null(:string)
    @desc "Callsign of the reporting station"
    field :reporter, non_null(:string)
    @desc "The grid location of the reporting station"
    field :reporter_grid, non_null(:string)
    @desc "The distance between stations in km"
    field :distance, non_null(:integer)
    field :azimuth, non_null(:string)
  end

  # Query definitions
  object :spot_queries do
    @desc "Search spots"
    field :search_spots, list_of(:spot) do
      @desc "Search by seen callsign"
      arg(:callsign, :string)
      arg(:band, :string)
      @desc "Search by reporter callsign"
      arg(:reporter, :string)
      @desc "Search by timeframe, 'week', 'month'"
      arg(:timeframe, :string)
      @desc "Minimum distance, in km"
      arg(:min_km, :integer)
      @desc "Maximum distance, in km"
      arg(:max_km, :integer)
      @desc "Limit for the number of results to return"
      arg(:limit, :integer)
      @desc "The column to order by (defaults to spot_dt)"
      arg(:order_by, :string)
      @desc "The diretion to order by, defaults to 'desc'"
      arg(:order_dir, :string)
      arg(:start_dt, :datetime)
      arg(:end_dt, :datetime)

      resolve(&SpotResolver.search_spots/3)
    end
  end
end
