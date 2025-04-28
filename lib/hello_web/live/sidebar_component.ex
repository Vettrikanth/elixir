defmodule HelloWeb.SidebarComponent do
  use Phoenix.LiveComponent

  @topic "counter"

  def mount(socket) do
    IO.inspect(self(), label: "SimpleSidebarComponent PID")
    case Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic) do
      :ok -> IO.inspect("SimpleSidebarComponent subscribed to #{@topic}")
      error -> IO.inspect(error, label: "SimpleSidebarComponent subscription error")
    end
    {:ok, assign(socket, counter: 0)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  # def handle_info({:counter_updated, counter}, socket) do
  #   IO.inspect({:received, counter}, label: "SimpleSidebarComponent")
  #   {:noreply, assign(socket, counter: counter)}
  # end

  # def mount(socket) do
  #   {:ok, assign(socket, counter: 0)}
  # end

  # def update(assigns, socket) do
  #   {:ok, assign(socket, counter: assigns.counter)}
  # end


  #   def mount(_params, _session, socket) do
  #   Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic)
  #   {:ok, assign(socket, counter: 0)}
  # end

  # def handle_info({:counter_updated, counter}, socket) do
  #   IO.inspect({:received, counter}, label: "PubSubDemoLive")
  #   {:noreply, assign(socket, counter: counter)}
  # end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Simple Sidebar</h1>
      <p>Counter: <%= @counter %></p>
    </div>
    """
  end
end
