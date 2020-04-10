use Mix.Config

# Configure your database
config :wspr_hub, WsprHub.Repo,
  username: "postgres",
  password: "postgres",
  database: "wspr_hub_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wspr_hub, WsprHubWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure Guardian
config :wspr_hub, WsprHub.Guardian,
  issuer: "wspr_hub",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")
