defmodule HelloWeb.PubSubDemoLive do
  use HelloWeb, :live_view

  @topic "counter"

  def mount(_params, _session, socket) do
    # The parent LiveView subscribes to the topic
    Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic)
    {:ok, assign(socket, count: 0)}
  end

  def handle_info({:counter_updated, count}, socket) do
    # When we receive a broadcast, update our state
    IO.inspect(count, label: "Parent LiveView received")
    # Send the updated count to all components
    send_update(HelloWeb.SidebarComponent, id: "sidebar", counter: count)
    {:noreply, assign(socket, count: count)}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <h1>Pub Sub Demo</h1>
      <div class="row">
        <div class="column">
          <.live_component module={HelloWeb.CounterComponent} id="counter" />
        </div>
        <div class="column">
          <.live_component module={HelloWeb.SidebarComponent} id="sidebar" />
        </div>
      </div>
    </div>
    """
  end
end
