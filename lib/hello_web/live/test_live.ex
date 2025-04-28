defmodule HelloWeb.TestLive do
  use HelloWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "TestLive PID")
    case Phoenix.PubSub.subscribe(HelloWeb.PubSub, "test") do
      :ok -> IO.inspect("TestLive subscribed to test")
      error -> IO.inspect(error, label: "TestLive subscription error")
    end
    {:ok, assign(socket, counter: 0)}
  end

  def handle_info({:test_updated, counter}, socket) do
    IO.inspect({:received, counter}, label: "TestLive")
    {:noreply, assign(socket, counter: counter)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <p>Counter: <%= @counter %></p>
      <button phx-click="test">Test Broadcast</button>
    </div>
    """
  end

  def handle_event("test", _, socket) do
    counter = socket.assigns.counter + 1
    Phoenix.PubSub.broadcast(HelloWeb.PubSub, "test", {:test_updated, counter})
    {:noreply, assign(socket, counter: counter)}
  end
end
