defmodule WsprHubWeb.Resolvers.BandResolver do
  def list_bands(_root, _args, _info) do
    bands = HamRadio.Band.bands()

    {:ok, bands}
  end
end
