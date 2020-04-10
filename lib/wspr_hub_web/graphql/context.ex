defmodule WsprHubWeb.Context do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- WsprHub.Guardian.decode_and_verify(token),
         {:ok, current_user} <- WsprHub.Guardian.resource_from_claims(claims) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end
end
