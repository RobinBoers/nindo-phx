defmodule NindoPhxWeb.LayoutView do
  @moduledoc false

  use NindoPhxWeb, :view
  alias NindoPhxWeb.{Endpoint, Live}

  alias NindoPhxWeb.{AlertComponent, UIComponent}

  import Routes
  import Nindo.Core

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def header_classes(true), do: "hidden"
  def header_classes(_), do: "bg-indigo-500 text-blue-50 shadow-lg"

end
