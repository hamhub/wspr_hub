defmodule WsprHubWeb.Schema do
  use Absinthe.Schema
  alias WsprHubWeb.Resolvers.{SpotResolver}

  import_types(Absinthe.Type.Custom)
  import_types(WsprHubWeb.Schema.BandTypes)
  import_types(WsprHubWeb.Schema.SpotTypes)

  query do
    @desc "Get all spots, limited to previous month and 50 entries"
    field :all_spots, non_null(list_of(non_null(:spot))) do
      resolve(&SpotResolver.list_spots/3)
    end

    import_fields(:spot_queries)
    import_fields(:band_queries)
  end
end
