defmodule HelloWeb.PubSubDemoLive do
  use HelloWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_info({:counter_updated, count}, socket) do
    {:noreply, assign(socket, :count, count)}
  end

  # @topic "counter"

  # def mount(_params, _session, socket) do
  #   Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic)
  #   {:ok, assign(socket, counter: 0)}
  # end

  # def handle_info({:counter_updated, counter}, socket) do
  #   IO.inspect({:received, counter}, label: "PubSubDemoLive")
  #   {:noreply, assign(socket, counter: counter)}
  # end

  def render(assigns) do
    ~H"""
    <div class = "container">
      <h1>Pub Sub Demo</h1>
      <div class = "row">
        <div class = "column">
        <%!-- <h2>counter component</h2> --%>
        <.live_component module={HelloWeb.CounterComponent} id="counter" />
        </div>
        <div class = "column">
        <%!-- <h2>sidebar component</h2> --%>
        <.live_component module={HelloWeb.SidebarComponent} id="sidebar"  />
        </div>
      </div>
    </div>
  """
  end

end
