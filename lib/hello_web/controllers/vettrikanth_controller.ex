defmodule HelloWeb.VettrikanthController do
  use HelloWeb, :controller

  def index(conn, _params)do
    render(conn ,:index)
  end

end
