defmodule NindoPhxWeb.LayoutView do
  @moduledoc false

  use NindoPhxWeb, :view
  alias NindoPhxWeb.{Endpoint, Live}

  alias NindoPhxWeb.{AlertComponent, UIComponent}

  import Routes
  import Nindo.Core

  # No warnings if LiveDashboard is missing
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def header_classes(true), do: "hidden"
  def header_classes(_), do: "bg-indigo-500 text-blue-50 shadow-lg print:hidden"
end
