defmodule HelloWeb.SidebarComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    IO.inspect(self(), label: "SidebarComponent PID")
    {:ok, assign(socket, counter: 0)}
  end

  # Handle updates sent from the parent LiveView
  def update(%{counter: counter} = assigns, socket) do
    IO.inspect(counter, label: "SidebarComponent received update")
    {:ok, assign(socket, counter: counter)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
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
