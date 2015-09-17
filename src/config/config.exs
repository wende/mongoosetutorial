# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :mongoosetutorial, Mongoosetutorial.Endpoint,
  http: [port: System.get_env("PORT") || 4001],
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "hYV8EZSCfXnfMweW099zksgY1n+XcUs4CNZBHlF4nwsTAU7s5S9OX8R8yRC+Ev4u",
  render_errors: [default_format: "html"],
  pubsub: [name: Mongoosetutorial.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :hedwig, :clients,
   [%{
			 jid: "test@localhost",
			 password: "test",
			 nickname: "test",
			 rooms: [
				 "test@localhost"
			 ],
			config: %{
				require_tls?: false,
				use_compression?: false,
				use_stream_management?: true,
				transport: :tcp
			},
			handlers: [{Mongoosetutorial.Handlers.Echo, %{}}]
}]
		
import_config "#{Mix.env}.exs"
		
