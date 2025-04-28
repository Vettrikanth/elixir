defmodule HelloWeb.PubSubDemoLive do
  use HelloWeb, :live_view

  def mount(_params, _session, socket) do
    # Parent doesn't manage PubSub - just renders components
    {:ok, socket}
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
