defmodule Mongoosetutorial.XMPPTest do
	use ExUnit.Case

	test "Our first test" do
		client = %{
			jid: "yellow@localhost",
			password: "thepw",
			nickname: "yellow",
			rooms: [
				"yellow@localhost"
			],
			config: %{
				require_tls?: false,
				use_compression?: false,
				use_stream_management?: true,
				transport: :tcp
			},
			handlers: [{Hedwig.Handlers.Echo, %{}}]
			   }
		{:ok, hedwig_pid} = Hedwig.Client.start_link(client)

		IO.inspect hedwig_pid
	end
end
