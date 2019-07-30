defmodule WsprHub.Repo.Migrations.CreateSpots do
  use Ecto.Migration

  def change do
    create table(:spots) do
      add :spot_dt, :utc_datetime
      add :reporter, :string
      add :reporter_grid, :string
      add :snr, :integer
      add :frequency, :float
      add :callsign, :string
      add :grid, :string
      add :power, :integer
      add :drift, :integer
      add :distance, :integer
      add :azimuth, :integer
      add :band, :string
      add :version, :string
      add :code, :string
      add :ext_id, :integer

      timestamps()
    end

    create index("spots", [:spot_dt], order_by: [desc: :spot_dt])
    create unique_index(:spots, [:ext_id])
  end
end
