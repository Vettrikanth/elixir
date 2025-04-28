#side_bar_live.ex
defmodule HelloWeb.SidebarLive do
alias Phoenix.PubSub
  use HelloWeb, :live_view
  @topic "counter"
  def mount(_, %{"counter" => _counter}, socket) do
    if connected?(socket), do: PubSub.subscribe(HelloWeb.PubSub , @topic)
    {:ok , assign(socket,counter: 0)}
  end

  def handle_info({:counter_updated, counter}, socket) do
    {:noreply, assign(socket, counter: counter)}
  end

  def render(assigns) do
    ~H"""
    <div class="sidebar">
      <h1>Sidebar Live View</h1>
      <p>Current counter value: <%= @counter %></p>
    </div>
    """
  end

end
