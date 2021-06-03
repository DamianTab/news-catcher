# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :catcher,
  ecto_repos: [Catcher.Repo]

# Configures the endpoint
config :catcher, CatcherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j6fWeUPAvtEbKHHPg7uG3v5mOUoRwRy/6d8rocgAGJ9oEpcqop14Aj8YR6j6FxHN",
  render_errors: [view: CatcherWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Catcher.PubSub,
  live_view: [signing_salt: "DC5ZgWAl"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
