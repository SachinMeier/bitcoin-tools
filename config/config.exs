# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config



config :bitcoin_web,
  generators: [context_app: :bitcoin]

# Configures the endpoint
config :bitcoin_web, BitcoinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D9NrUXsoPDeyM6pfyh18WOGF3wTZTvo/d5SuH3G0WYKuIaSTuTAsFFyyGWHiyvzL",
  render_errors: [view: BitcoinWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bitcoin.PubSub,
  live_view: [signing_salt: "te1l/c3M"],
  force_ssl: [hsts: true, rewrite_on: [:x_forwarded_proto]]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :money,
  custom_currencies: [
    BTC: %{name: "Bitcoin", symbol: "₿", exponent: 8}
  ],
  default_currency: :BTC

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
