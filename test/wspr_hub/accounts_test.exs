defmodule WsprHub.AccountsTest do
  use WsprHub.DataCase
  alias WsprHub.Accounts

  describe "users" do
    alias WsprHub.Accounts.User
    import WsprHub.Factory

    @invalid_attrs %{
      display_name: nil,
      encrypted_password: nil,
      grid: nil,
      location: nil,
      station_info: nil,
      username: nil
    }

    test "list_users/0 returns all users" do
      user = insert(:user)
      [fetched_user] = Accounts.list_users()
      assert fetched_user.id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      fetched_user = Accounts.get_user!(user.id)
      assert fetched_user.id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      user_params = params_for(:user, %{encrypted_password: "fakepassword"})
      result = Accounts.create_user(user_params)

      assert {:ok, %User{} = user} = result
      assert user.email == user_params.email
      assert user.callsign == user_params.callsign
      assert user.display_name == user_params.display_name
      assert is_nil(user.encrypted_password)
      assert user.grid == user_params.grid
      assert user.location == user_params.location
      assert user.station_info == user_params.station_info
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with password updates the password" do
      user_params = params_for(:user, %{password: "Password123"})
      result = Accounts.create_user(user_params)

      assert {:ok, %User{} = user} = result
      assert user.email == user_params.email
      assert user.callsign == user_params.callsign
      assert user.display_name == user_params.display_name
      assert not is_nil(user.encrypted_password)
      assert user.grid == user_params.grid
      assert user.location == user_params.location
      assert user.station_info == user_params.station_info
    end

    test "register_user/1 without password fails" do
      result = Accounts.register_user(params_for(:user))

      assert {:error, cs} = result
      refute cs.valid?

      assert %{
               errors: [
                 password_confirmation: _,
                 password: {_, [validation: :required]},
                 password_confirmation: _
               ]
             } = cs
    end

    test "register_user/1 with simple password fails" do
      user_params =
        params_for(:user, %{password: "toosimple", password_confirmation: "toosimple"})

      result = Accounts.register_user(user_params)

      assert {:error, cs} = result
      refute cs.valid?
      assert %{errors: [password: {reason, [validation: :format]}]} = cs
      assert String.contains?(reason, "Must include")
    end

    test "register_user/1 without password confirmation fails" do
      user_params = params_for(:user, %{password: "NotSimple1"})

      result = Accounts.register_user(user_params)

      assert {:error, cs} = result
      refute cs.valid?

      assert %{
               errors: [
                 password_confirmation: {"does not match", [validation: :required]},
                 password_confirmation: {"can't be blank", [validation: :required]}
               ]
             } = cs
    end

    test "register_user/1 without matching password confirmation fails" do
      user_params =
        params_for(:user, %{password: "NotSimple1", password_confirmation: "NotSimple2"})

      result = Accounts.register_user(user_params)

      assert {:error, cs} = result
      refute cs.valid?
      assert %{errors: [password_confirmation: {_, [validation: :confirmation]}]} = cs
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user, %{encrypted_password: "fakepassword"})

      update_params =
        params_for(:user, %{
          display_name: "different name",
          grid: "different grid",
          location: "different location",
          station_info: "different station info"
        })

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_params)
      assert user.email == user.email
      assert user.email != update_params.email
      assert user.display_name == update_params.display_name
      assert not is_nil(user.encrypted_password)
      assert user.grid == update_params.grid
      assert user.location == update_params.location
      assert user.station_info == update_params.station_info
      assert user.email == user.email
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
