defmodule HelloWeb.CountLive do
  use HelloWeb, :live_view
  alias Hello.{Repo,Counter}

  def mount(_params, _session, socket) do
    counter = Repo.get(Counter,1)
    {:ok, assign(socket, :count, counter.count)}
  end

  def render(assigns) do
    ~H"""
    <h1>Live Count: <%= @count %></h1>
    <button phx-click="inc">+</button><br>
    <button phx-click="dec">-</button>
    """
  end

  defp update_db(value) do
    counter = Repo.get!(Counter, 1)
    changeset = Ecto.Changeset.change(counter, count: value)
    Repo.update!(changeset)
  end

  def handle_event("inc", _params, socket) do
    new_count = socket.assigns.count + 1
    update_db(new_count)
    {:noreply, assign(socket, :count, new_count)}
  end

  def handle_event("dec", _params, socket) do
    new_count = socket.assigns.count - 1
    update_db(new_count)
    {:noreply, assign(socket, :count, new_count)}
  end
  
end
