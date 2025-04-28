defmodule HelloWeb.TestSidebarComponent do
  use Phoenix.LiveComponent

  @topic "counter"

  def mount(socket) do
    IO.inspect(self(), label: "TestSidebarComponent PID")
    case Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic) do
      :ok -> IO.inspect("TestSidebarComponent subscribed to #{@topic}")
      error -> IO.inspect(error, label: "TestSidebarComponent subscription error")
    end
    {:ok, assign(socket, counter: 0)}
  end

  def update(assigns, socket) do
    case Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic) do
      :ok -> IO.inspect("TestSidebarComponent resubscribed in update/2")
      error -> IO.inspect(error, label: "TestSidebarComponent resubscription error")
    end
    {:ok, assign(socket, assigns)}
  end

  def handle_info({:counter_updated, counter}, socket) do
    IO.inspect({:received, counter}, label: "TestSidebarComponent")
    {:noreply, assign(socket, counter: counter)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Test Sidebar</h1>
      <p>Counter: <%= @counter %></p>
    </div>
    """
  end
end
