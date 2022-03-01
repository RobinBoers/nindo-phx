defmodule NindoPhxWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: NindoPhxWeb

      import Plug.Conn
      import NindoPhxWeb.Gettext
      import NindoPhxWeb.API.Auth, only: [authenticate_api_user: 2]
      alias NindoPhxWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/nindo_phx_web/templates",
        namespace: NindoPhxWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {NindoPhxWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import NindoPhxWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML
      import Phoenix.LiveView.Helpers
      import Phoenix.View

      import NindoPhxWeb.ErrorHelpers
      import NindoPhxWeb.Gettext
      alias NindoPhxWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
