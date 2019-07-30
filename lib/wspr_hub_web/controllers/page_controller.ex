defmodule WsprHubWeb.PageController do
  use WsprHubWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
