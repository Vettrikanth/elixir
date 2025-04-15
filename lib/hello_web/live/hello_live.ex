defmodule HelloWeb.HelloLive do
  use HelloWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello World in Live file !!!</h1>
    """
  end
end
