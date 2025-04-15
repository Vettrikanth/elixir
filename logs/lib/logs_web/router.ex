# lib/logs_web/router.ex
defmodule LogsWeb.Router do
  use LogsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LogsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", LogsWeb do
    pipe_through :browser

    live "/", AlarmLogsLive
  end
end
