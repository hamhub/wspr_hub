# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :wspr_hub,
  ecto_repos: [WsprHub.Repo]

# Configures the endpoint
config :wspr_hub, WsprHubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2QXku9lW+QEl9VjY58OMaB1uNnkDhqgkltN0iQ8ys3IgPHPqQ2NkKMGBq4wUIY73",
  render_errors: [view: WsprHubWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WsprHub.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
