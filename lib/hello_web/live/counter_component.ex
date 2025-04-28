defmodule HelloWeb.CounterComponent do
  use Phoenix.LiveComponent

  @topic "counter"

  def mount(socket) do
    IO.inspect(@topic, label: "counter Topic is")
    Phoenix.PubSub.subscribe(HelloWeb.PubSub, @topic)
    {:ok, assign(socket, counter: 0)}
  end

  def handle_event("increase_count", _unsigned_params, socket) do
    counter = socket.assigns.counter + 1
    IO.inspect({:broadcasting, counter, @topic}, label: "add button")
    case Phoenix.PubSub.broadcast(HelloWeb.PubSub, @topic, {:counter_updated, counter}) do
      :ok -> IO.inspect("Broadcast successful for counter: #{counter}")
      error -> IO.inspect(error, label: "Broadcast error")
    end
    {:noreply, assign(socket, :counter, counter)}
  end

  def handle_event("decrease_count", _unsigned_params, socket) do
    counter = socket.assigns.counter
    case counter do
      0 ->
        {:noreply, socket}
      _ ->
        counter = counter - 1
        IO.inspect({:broadcasting, counter, @topic}, label: "delete button")
        case Phoenix.PubSub.broadcast(HelloWeb.PubSub, @topic, {:counter_updated, counter}) do
          :ok -> IO.inspect("Broadcast successful for counter: #{counter}")
          error -> IO.inspect(error, label: "Broadcast error")
        end
        {:noreply, assign(socket, :counter, counter)}
    end
  end

  def handle_info({:counter_updated, counter}, socket) do
    {:noreply, assign(socket, counter: counter)}
  end

  def render(assigns) do
    ~H"""
    <div class="counter-container">
      <p class="counter">Counter: <%= @counter %></p>
      <div class="buttons">
        <button phx-click="increase_count" phx-target={@myself}>+</button>
        <button phx-click="decrease_count" phx-target={@myself}>-</button>
      </div>
    </div>
    """
  end
end
