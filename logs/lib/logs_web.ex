defmodule LogsWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use LogsWeb, :controller
      use LogsWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: LogsWeb.Layouts]

      use Gettext, backend: LogsWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

# Add these functions to your LogsWeb module in lib/logs_web.ex
# Inside the def live_view section:

def live_view do
  quote do
    use Phoenix.LiveView,
      layout: {LogsWeb.Layouts, :app}

    unquote(html_helpers())

    # Add this helper function for the template
    def severity_color_class(severity) do
      case severity do
        "high" -> "bg-red-100"
        "medium" -> "bg-yellow-100"
        "low" -> "bg-green-100"
        _ -> ""
      end
    end
  end
end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # Translation
      use Gettext, backend: LogsWeb.Gettext

      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components
      import LogsWeb.CoreComponents

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: LogsWeb.Endpoint,
        router: LogsWeb.Router,
        statics: LogsWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
