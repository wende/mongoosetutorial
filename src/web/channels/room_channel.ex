defmodule Mongoosetutorial.RoomChannel do
	use Phoenix.Channel

	def join("rooms:lobby", auth_msg, socket) do
    Kernel.send(self(), {:msgs, Agent.get(:news_ticker, &(&1))})
    {:ok, socket}
	end
	def join("rooms:" <> _private_room_id, _auth_msg, socket) do
	  {:error, %{reason: "unauthorized"}}
	end

  def handle_info({:msgs, msgs}, socket) do
    Enum.reverse(msgs)
    |> Enum.each(fn a -> push(socket, "message", %{"msg"=> a.body}) end)
    {:noreply, socket}
  end
end
