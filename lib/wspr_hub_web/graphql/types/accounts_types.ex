defmodule WsprHubWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: WsprHub.Repo

  alias WsprHubWeb.Resolvers.AccountsResolver

  object :accounts_user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :callsign, non_null(:string)
    field :display_name, non_null(:string)
    field :grid, :string
    field :location, :string
    field :station_info, :string
  end

  object :accounts_queres do
  end

  object :accounts_mutations do
    field :create_user, type: :accounts_user do
      arg(:email, non_null(:string))
      arg(:display_name, non_null(:string))
      arg(:callsign, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))

      resolve(&AccountsResolver.create_user/3)
    end
  end
end
