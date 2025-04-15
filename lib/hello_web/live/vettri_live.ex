defmodule HelloWeb.VettriLive do
  use HelloWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Hiii there vettri live</h1>
    """
  end
end
