defmodule NindoPhxWeb.UIComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  import NindoPhxWeb.{Router.Helpers}

  def sidebar(assigns) do
    ~H"""
      <div class="sidebar">
        <ul class="flex items-center justify-center flex-wrap block lg:hidden">
          <li class="header-item"><%= link "Home", to: social_path(@conn, :index) %></li>
          <li class="header-item"><%= link "Discover", to: social_path(@conn, :discover) %></li>
          <li class="header-item"><%= link "Sources", to: rss_path(@conn, :sources) %></li>
          <li class="header-item"><%= link "Settings", to: account_path(@conn, :index) %></li>
        </ul>

        <ul class="flex flex-col items-start justify-start flex-wrap hidden lg:block">
          <li class="header-item"><%= link "Home", to: social_path(@conn, :index) %></li>
          <li class="header-item"><%= link "Discover", to: social_path(@conn, :discover) %></li>
          <li class="header-item"><%= link "Sources", to: rss_path(@conn, :sources) %></li>
          <li class="header-item"><%= link "Settings", to: account_path(@conn, :index) %></li>
        </ul>
      </div>
    """
  end
end
