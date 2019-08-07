defmodule WsprHubWeb.Queries.AccountsTest do
  use WsprHubWeb.ConnCase
  import WsprHub.Factory

  alias WsprHubWeb.Schema

  @default_user graphql_params_for(:user, %{
                  password: "NotSimple1",
                  password_confirmation: "NotSimple2"
                })

  test "create a user" do
    result =
      create_user_query()
      |> Absinthe.run(Schema, variables: @default_user)

    assert {:ok, %{data: %{"createUser" => created_user}}} = result
    assert not is_nil(created_user)
  end

  defp create_user_query() do
    """
    mutation(
      $email: String!,
      $displayName: String!,
      $callsign: String!,
      $password: String!,
      $passwordConfirmation: String!
    )  {
      createUser(
        email: $email,
        displayName: $displayName,
        callsign: $callsign,
        password: $password,
        passwordConfirmation: $passwordConfirmation
      ) {
        id
        email
      }
    }
    """
  end
end
