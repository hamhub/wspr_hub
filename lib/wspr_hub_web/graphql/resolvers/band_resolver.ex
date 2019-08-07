defmodule WsprHubWeb.Resolvers.BandResolver do
  def list_bands(_root, _args, _info) do
    bands = HamRadio.Bands.list()

    {:ok, bands}
  end
end
