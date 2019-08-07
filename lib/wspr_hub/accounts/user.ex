defmodule WsprHub.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias WsprHub.Accounts.Encryption

  schema "users" do
    field :callsign, :string
    field :display_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :grid, :string
    field :location, :string
    field :station_info, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :callsign,
      :display_name,
      :password,
      :location,
      :grid,
      :station_info
    ])
    |> validate_required([
      :email,
      :display_name,
      :callsign
    ])
    |> validate_user()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :callsign,
      :display_name,
      :password,
      :location,
      :grid,
      :station_info
    ])
    |> validate_required([
      :display_name,
      :callsign
    ])
    |> validate_user()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :callsign,
      :display_name,
      :location,
      :grid,
      :station_info,
      :password,
      :password_confirmation
    ])
    |> validate_required([
      :email,
      :password,
      :password_confirmation,
      :display_name,
      :callsign
    ])
    |> validate_confirmation(:password, message: "does not match", required: true)
    |> validate_user()
  end

  def validate_user(user) do
    user
    |> validate_length(:email, min: 5, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*/,
      message: "Must include at least one lowercase letter, one uppercase letter, and one digit"
    )
    |> encrypt_password()
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :encrypted_password, encrypted_password)
    else
      changeset
    end
  end
end
