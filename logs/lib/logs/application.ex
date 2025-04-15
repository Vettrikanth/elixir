# lib/logs/application.ex
defmodule Logs.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Logs.Repo,
      # Start the Telemetry supervisor
      LogsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Logs.PubSub},
      # Start the Endpoint (http/https)
      LogsWeb.Endpoint
      # Start a worker by calling: Logs.Worker.start_link(arg)
      # {Logs.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Logs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LogsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
