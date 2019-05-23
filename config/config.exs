# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :monarchive,
  ecto_repos: [Monarchive.Repo]

# Configures the endpoint
config :monarchive, MonarchiveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zsIX0OA8QfzbE5H7zV7EFaRLV6lVjSHF0v/LDGOky+V4wUaEMhrOXIiNxozsX9V9",
  render_errors: [view: MonarchiveWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Monarchive.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
