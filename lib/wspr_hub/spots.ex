defmodule WsprHub.Spots do
  @moduledoc """
  The Spots context.
  """

  import Ecto.Query, warn: false
  alias WsprHub.Repo

  alias WsprHub.Spots.Spot

  @doc """
  Returns the list of spots.

  ## Examples

      iex> list_spots()
      [%Spot{}, ...]

  """
  def list_spots(timeframe \\ :forever) do
    Spot
    |> Spot.by_timeframe(timeframe)
    |> Repo.all()
  end

  @doc """
  Gets a single spot.

  Raises `Ecto.NoResultsError` if the Spot does not exist.

  ## Examples

      iex> get_spot!(123)
      %Spot{}

      iex> get_spot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spot!(id), do: Repo.get!(Spot, id)

  @doc """
  Creates a spot.

  ## Examples

      iex> create_spot(%{field: value})
      {:ok, %Spot{}}

      iex> create_spot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spot(attrs \\ %{}) do
    %Spot{}
    |> Spot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spot.

  ## Examples

      iex> update_spot(spot, %{field: new_value})
      {:ok, %Spot{}}

      iex> update_spot(spot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spot(%Spot{} = spot, attrs) do
    spot
    |> Spot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Spot.

  ## Examples

      iex> delete_spot(spot)
      {:ok, %Spot{}}

      iex> delete_spot(spot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spot(%Spot{} = spot) do
    Repo.delete(spot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spot changes.

  ## Examples

      iex> change_spot(spot)
      %Ecto.Changeset{source: %Spot{}}

  """
  def change_spot(%Spot{} = spot) do
    Spot.changeset(spot, %{})
  end

  def search_spots(args) do
    args
    |> Map.keys()
    |> Enum.reduce(Spot, fn
      :callsign, query -> Spot.by_callsign(query, args[:callsign])
      :reporter, query -> Spot.by_reporter(query, args[:reporter])
      :timeframe, query -> Spot.by_timeframe(query, args[:timeframe])
      :band, query -> Spot.by_band(query, args[:band])
      _, query -> query
    end)
    |> Spot.by_distance(args[:min_km], args[:max_km])
    |> Spot.by_date_range(args[:start_dt], args[:end_dt])
    |> Spot.limit(args[:limit])
    |> Spot.order_by(args[:order_by], args[:order_dir])
    |> Repo.all()
  end
end
