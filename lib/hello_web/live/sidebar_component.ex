defmodule HelloWeb.SidebarComponent do
  use Phoenix.LiveComponent

  @topic "counter"

  def mount(socket) do
    # Initialize state
    {:ok, assign(socket, counter: 0)}
  end

  def update(assigns, socket) do
    if socket.assigns[:pubsub_initialized] != true do
      # Subscribe to the PubSub topic only on the first update
      if connected?(socket) do
        Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic)
        IO.inspect("SidebarComponent subscribed to #{@topic}")
      end
      {:ok, assign(socket, Map.merge(assigns, %{pubsub_initialized: true}))}
    else
      {:ok, assign(socket, assigns)}
    end
  end

  # Handle the PubSub messages
  def handle_info({:counter_updated, counter}, socket) do
    IO.inspect(counter, label: "SidebarComponent received")
    {:noreply, assign(socket, counter: counter)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Simple Sidebar</h1>
      <p>Counter: <%= @counter %></p>
    </div>
    """
  end
end
