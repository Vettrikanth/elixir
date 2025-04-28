#counter_live.ex
defmodule HelloWeb.CounterLive do
  use HelloWeb, :live_view
  alias Phoenix.PubSub

  @topic "counter"

  def mount(_, session ,socket) do
    if connected?(socket) , do: PubSub.subscribe(HelloWeb.PubSub, @topic)

    counter = Map.get(session, "counter", 0)
    {:ok , assign(socket,counter: counter)}
  end

  def handle_event("increase_count", _unsigned_params, socket) do
    counter = socket.assigns.counter + 1
    PubSub.broadcast(HelloWeb.PubSub, @topic , {:counter_updated, counter})
    {:noreply , assign(socket, :counter, counter)}
  end

  def handle_event("decrease_count", _unsigned_params, socket) do
    counter = socket.assigns.counter

    case counter do
      0 ->
        {:noreply , socket}

      _ ->
        counter = counter - 1

        PubSub.broadcast(HelloWeb.PubSub, @topic , {:counter_updated, counter})
        {:noreply,assign(socket,:counter , counter)}
    end
  end

  def render(assigns) do

    ~H"""
  <p class = "counter"> Counter <%= @counter %> </p>
  <button phx-click="increase_count">+</button>
  <button phx-click="decrease_count">-</button>
  """

  end

end
