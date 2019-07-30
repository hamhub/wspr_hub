defmodule WsprHubWeb.PostController do
  use WsprHubWeb, :controller

  # Two functions. wspr and wsprstat

  ## wspr
  # date
  # time
  # sig
  # dt
  # drift
  # tqrg
  # tcall
  # tgrid
  # dbm

  ## wsprstat
  # rcall
  # rgrid
  # rqrg
  # tpct
  # tqrg
  # dbm
  # version

  def index(conn, _params) do
    # params
    # |> IO.inspect()

    json(conn, %{id: "100"})
  end

  def submit(conn, %{"function" => "wsprstat"}) do
    # params
    # |> IO.inspect()

    json(conn, %{id: "wsprstat"})
  end

  def submit(conn, %{"function" => "wspr"}) do
    # params
    # |> IO.inspect()

    json(conn, %{id: "wspr"})
  end

  def submit(conn, _params) do
    # params
    # |> IO.inspect()

    json(conn, %{id: "unknown"})
  end
end
