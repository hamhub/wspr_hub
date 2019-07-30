defmodule WsprHubWeb.PageControllerTest do
  use WsprHubWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "root"
  end
end
