defmodule Mongoosetutorial.Handlers.Echo do
	  @moduledoc """
  A completely useless echo script.
  This script simply echoes the same message back.
  """
    
		@usage nil
		use Hedwig.Handler

    def init(opts) do
      Agent.start_link fn -> [] end, name: :news_ticker
      {:ok, opts}
    end
    
		def handle_event(%Message{} = msg, opts) do
      Agent.update :news_ticker, fn state ->
        [msg | state] |> Enum.take(3)
      end
      Mongoosetutorial.Endpoint.broadcast! "rooms:lobby", "message", %{ :msg => msg.body}
			{:ok, opts}
		end

		def handle_event(_, opts), do: {:ok, opts}
end
