defmodule NindoPhxWeb.UIComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{Accounts, Format}
  alias NindoPhxWeb.{Endpoint, Live}
  import NindoPhxWeb.Router.Helpers

  import Nindo.Core

  def sidebar(assigns) do
    ~H"""
      <div class="sidebar">
        <ul class="flex items-center justify-center flex-wrap flex-row xl:flex-col xl:items-start xl:justify-start">
          <%= if @logged_in do %>
            <li class="header-item"><%= link safe("<i class='fas fa-home mr-1'></i> Home"), to: live_path(Endpoint, Live.Social) %></li>
          <% end %>
          <li class="header-item"><%= link safe("<i class='fas fa-compass mr-1'></i> Discover"), to: social_path(Endpoint, :discover) %></li>
          <li class="header-item"><%= link safe("<i class='fas fa-stream mr-1'></i> Sources"), to: social_path(Endpoint, :sources) %></li>
          <li class="header-item hidden sm:block"><%= link safe("<i class='fas fa-user mr-1'></i> Settings"), to: account_path(Endpoint, :index) %></li>
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

      <%= link "Logout", to: account_path(Endpoint, :logout), class: "header-item header-button btn-secondary hidden lg:block" %>
    """
  end

  def dev_header(assigns) do
    ~H"""
    <div class="bg-yellow-400">
      <div class="py-1.5 pl-3 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between flex-wrap">
          <div class="flex-1 flex items-center text-black">
            <span class="flex p-2 rounded-lg bg-yellow-600">
              <i class="fas fa-database text-lg"></i>
            </span>
            <p class="ml-3 font-medium truncate text-black">
              <span class="md:hidden text-black">
                Look out! In development!
              </span>
              <span class="hidden md:inline text-black">
                Look out! Nindo is still in active development and can be very unstable.
              </span>
            </p>
          </div>
          <div class="order-3 hidden sm:block flex-shrink-0 w-full sm:w-auto">
            <a href="https://robinboers.github.io/nindo-phx" class="btn-secondary p-2 bg-white hover:bg-gray-50 text-yellow-700 border border-yellow-600">
              Documentation
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
