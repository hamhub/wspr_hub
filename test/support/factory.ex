defmodule WsprHub.Factory do
  use ExMachina.Ecto, repo: WsprHub.Repo

  alias WsprHub.Spots.Spot

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
end
