defmodule WsprHub.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :callsign, :string
      add :primary_callsign, :string
      add :encrypted_password, :string
      add :display_name, :string
      add :location, :string
      add :grid, :string
      add :station_info, :text

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
