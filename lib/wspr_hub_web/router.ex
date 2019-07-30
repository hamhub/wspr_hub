defmodule WsprHubWeb.Router do
  use WsprHubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/post", WsprHubWeb do
    pipe_through :api

    get "/", PostController, :index
    post "/", PostController, :submit
  end

  forward "/graphql", Absinthe.Plug, schema: WsprHubWeb.Schema

  # forward "/graphql",
  #   to: Absinthe.Plug,
  #   init_opts: [schema: WsprHubWeb.Schema]

  # forward "/graphiql",
  #   to: Absinthe.Plug.GraphiQL,
  #   init_opts: [
  #     schema: WsprHubWeb.Schema,
  #     interface: :simple
  #   ]

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: WsprHubWeb.Schema,
    interface: :simple,
    context: %{pubsub: WsprHubWeb.Endpoint}

  # Other scopes may use custom stacks.
  # scope "/api", WsprHubWeb do
  #   pipe_through :api
  # end

  scope "/", WsprHubWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
