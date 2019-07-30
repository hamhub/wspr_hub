defmodule WsprHubWeb.Schema.BandTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: WsprHub.Repo

  alias WsprHubWeb.Resolvers.BandResolver

  object :band do
    field :id, non_null(:string)
    field :name, non_null(:string)
    field :max, non_null(:integer)
    field :min, non_null(:integer)
    field :default_unit, non_null(:string)
  end

  object :band_queries do
    field :bands, list_of(:band) do
      resolve(&BandResolver.list_bands/3)
    end
  end
end
