defmodule NindoPhxWeb.UIComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{Accounts, Format}
  import NindoPhxWeb.Router.Helpers

  import Nindo.Core

  def sidebar(assigns) do
    ~H"""
      <div class="sidebar">
        <ul class="flex items-center justify-center flex-wrap flex-row xl:flex-col xl:items-start xl:justify-start">
          <%= if logged_in?(@conn) do %>
            <li class="header-item"><%= link safe("<i class='fas fa-home icon'></i> Home"), to: social_path(@conn, :index) %></li>
          <% end %>
          <li class="header-item"><%= link safe("<i class='fas fa-compass icon'></i> Discover"), to: social_path(@conn, :discover) %></li>
          <li class="header-item"><%= link safe("<i class='fas fa-stream icon'></i> Sources"), to: social_path(@conn, :sources) %></li>
          <li class="header-item"><%= link safe("<i class='fas fa-user icon'></i> Settings"), to: account_path(@conn, :index) %></li>
        </ul>
      </div>
    """
  end

  def account_header(assigns) do
    account = Accounts.get(assigns.id)

    ~H"""
      <p class="header-item">
        <a href="/account">
          <img
            class="w-5 object-cover h-5 inline mr-1 rounded-full border border-indigo-700 border-2"
            src={Format.profile_picture(account.username)}
          >
          <span> <%= Format.display_name(account.username) %></span>
        </a>
      </p>

      <%= link "Logout", to: account_path(@conn, :logout), class: "header-item header-button btn-secondary hidden lg:block" %>
    """
  end
end
