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

  test "authenticate a user session" do
    create_user_query()
    |> Absinthe.run(Schema, variables: @default_user)

    result =
      authenticate_user_query()
      |> Absinthe.run(Schema,
        variables: %{"email" => @default_user["email"], "password" => @default_user["password"]}
      )

    assert {:ok, %{data: %{"authenticateUser" => %{"token" => token}}}} = result
    assert {:ok, %{} = claim} = WsprHub.Guardian.decode_and_verify(token)
    assert {:ok, _user} = WsprHub.Guardian.resource_from_claim(claim)
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

  defp authenticate_user_query() do
    """
    mutation($email: String!, $password: String!) {
      authenticateUser(email: $email, password: $password) {
        token
      }
    }
    """
  end
end
