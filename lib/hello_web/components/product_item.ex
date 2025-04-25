defmodule HelloWeb.ProductItem do
  use Phoenix.Component


  def product_item(assigns) do
    ~H"""
    <div class="flex items-center justify-between mb-4">
      <span class="font-medium">Product <%= @id %></span>
      <span>Count: <%= @count %></span>
      <button phx-click="add" phx-value-id={@id}>+</button>
    </div>
    """
  end

end
