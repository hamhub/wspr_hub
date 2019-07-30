defmodule WsprHub.Repo do
  use Ecto.Repo,
    otp_app: :wspr_hub,
    adapter: Ecto.Adapters.Postgres
end
