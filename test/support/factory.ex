defmodule WsprHub.Factory do
  use ExMachina.Ecto, repo: WsprHub.Repo

  alias WsprHub.Spots.Spot
  alias WsprHub.Accounts.User
  alias Absinthe.Utils

  def spot_factory do
    %Spot{
      azimuth: 113,
      band: "20m",
      callsign: sequence(:callsigns, &"WW#{&1}DX"),
      code: "",
      distance: 815,
      drift: 0,
      frequency: 14.097085,
      grid: "EN35oi",
      power: 23,
      reporter: sequence(:callsigns, &"WW#{&1}DX"),
      reporter_grid: "some reporter_grid",
      snr: -19,
      spot_dt: DateTime.utc_now(),
      version: "0.9_r1",
      ext_id: sequence(:ext_ids, &to_string/1)
    }
  end

  def user_factory do
    %User{
      email: sequence(:email, &"email.#{&1}@example.com"),
      display_name: "Test User",
      callsign: sequence(:callsign, &"KD#{&1}DEP"),
      grid: "EN50jd",
      location: "Nowheresville, KT",
      station_info: "Operating 1501 Watts using a toaster and a car battery."
    }
  end

  def graphql_params_for(factory_name, attrs) do
    factory_name
    |> string_params_for(attrs)
    |> Enum.into(%{}, fn {key, value} ->
      {Utils.camelize(key, lower: true), value}
    end)
  end
end
