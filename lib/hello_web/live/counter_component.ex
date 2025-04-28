defmodule HelloWeb.CounterComponent do
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
        IO.inspect("CounterComponent subscribed to #{@topic}")
      end
      {:ok, assign(socket, Map.merge(assigns, %{pubsub_initialized: true}))}
    else
      {:ok, assign(socket, assigns)}
    end
  end

  def handle_event("increase_count", _unsigned_params, socket) do
    counter = socket.assigns.counter + 1
    IO.inspect({:broadcasting, counter, @topic}, label: "add button")

    # Broadcast the counter update
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

        # Broadcast the counter update
        case Phoenix.PubSub.broadcast(HelloWeb.PubSub, @topic, {:counter_updated, counter}) do
          :ok -> IO.inspect("Broadcast successful for counter: #{counter}")
          error -> IO.inspect(error, label: "Broadcast error")
        end

        {:noreply, assign(socket, :counter, counter)}
    end
  end

  # Handle the PubSub messages
  def handle_info({:counter_updated, counter}, socket) do
    IO.inspect(counter, label: "CounterComponent received")
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
