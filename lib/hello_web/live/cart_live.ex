defmodule HelloWeb.CartLive do
  use HelloWeb, :live_view
  import HelloWeb.ProductItem

  def mount(_params, _session, socket) do
    {:ok, assign(socket, product_counts: %{}, total_items: 0)}
  end

  # def update(assigns, socket) do
  #   socket =
  #     socket
  #     |> assign(assigns)
  #     |> assign_new(:count, fn -> 0 end)  # Initialize count if not provided
  #   {:ok, socket}
  # end

  def handle_params(params, _, socket) do
      name = params["name"] || "guest"
      {:noreply, assign(socket, name: name)}
  end

  def render(assigns)do
    ~H"""
    hiii <%= @name%> total items: <%= @total_items  %>
    <br>
    <br>
    <%= for id <- 1..3 do %>
    <.product_item id={id}  count={Map.get(@product_counts, id, 0)}/>
    <% end %>

    """
  end

  def handle_event("add", %{"id" => id}, socket) do
    id = String.to_integer(id)

    # Update the specific product count
    product_counts = Map.update(socket.assigns.product_counts, id, 1, &(&1 + 1))

    # Calculate total from all product counts
    total_items = Enum.sum(Map.values(product_counts))

    # Update both values in socket
    {:noreply, assign(socket, product_counts: product_counts, total_items: total_items)}
  end


end
