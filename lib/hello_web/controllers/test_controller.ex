defmodule HelloWeb.TestController do
  use HelloWeb, :controller

  def testfun(conn,_parms) do
    render(conn, :test)
  end

end
