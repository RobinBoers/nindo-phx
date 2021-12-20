defmodule NindoPhxWeb.UIComponent do
  @moduledoc """
  Module to render various UI components.
  """

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{Accounts, Format}
  alias NindoPhxWeb.{Endpoint, Live}
  import NindoPhxWeb.Router.Helpers

  @doc """
  The sidebar for LiveView.

  Uses `Phoenix.LiveView.Helpers.live_patch/2` for snappy navigation. The icons are from [Heroicons](https://heroicons.com).
  """
  def sidebar(assigns) do
    ~H"""
      <div class="sidebar">
        <ul class="flex items-center justify-center flex-wrap flex-row xl:flex-col xl:items-start xl:justify-start">
          <%= if @logged_in do %>
            <li class="header-item">
              <%= live_patch to: live_path(Endpoint, Live.Social) do %>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1 align-text-top inline" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z" />
                </svg>
                Home
              <% end %>
            </li>
          <% end %>
          <li class="header-item">
            <%= live_patch to: live_path(Endpoint, Live.Discover) do %>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1 align-text-top inline" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M9.243 3.03a1 1 0 01.727 1.213L9.53 6h2.94l.56-2.243a1 1 0 111.94.486L14.53 6H17a1 1 0 110 2h-2.97l-1 4H15a1 1 0 110 2h-2.47l-.56 2.242a1 1 0 11-1.94-.485L10.47 14H7.53l-.56 2.242a1 1 0 11-1.94-.485L5.47 14H3a1 1 0 110-2h2.97l1-4H5a1 1 0 110-2h2.47l.56-2.243a1 1 0 011.213-.727zM9.03 8l-1 4h2.938l1-4H9.031z" clip-rule="evenodd" />
              </svg>
              Discover
            <% end %>
          </li>
          <li class="header-item">
            <%= live_patch to: live_path(Endpoint, Live.Sources) do %>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1 align-text-top inline" viewBox="0 0 20 20" fill="currentColor">
                <path d="M7 3a1 1 0 000 2h6a1 1 0 100-2H7zM4 7a1 1 0 011-1h10a1 1 0 110 2H5a1 1 0 01-1-1zM2 11a2 2 0 012-2h12a2 2 0 012 2v4a2 2 0 01-2 2H4a2 2 0 01-2-2v-4z" />
              </svg>
              Sources
            <% end %>
          </li>
          <li class="header-item hidden sm:block">
            <%= live_patch to: live_path(Endpoint, Live.Account) do %>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1 align-text-top inline" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
              </svg>
              Settings
            <% end %>
          </li>
        </ul>
      </div>
    """
  end

  @doc """
  Component to show the little user avatar and name in the top-right of the screen. Also includes the logout button.
  """
  def account_header(assigns) do
    account = Accounts.get(assigns.id)

    ~H"""
      <p class="header-item">
        <a href="/account">
          <img
            class="w-5 object-cover h-5 inline mr-1 rounded-full border border-indigo-700 border-2"
            src={Format.profile_picture(account.username)}
          >
          <span><%= Format.display_name(account.username) %></span>
        </a>
      </p>

      <%= link "Logout", to: account_path(Endpoint, :logout), class: "header-item header-button btn-secondary hidden lg:block" %>
    """
  end

  @doc """
  Big yellow banner to show you're running a development version with a link to the docs.
  """
  def dev_header(assigns) do
    ~H"""
    <div class="bg-yellow-400">
      <div class="py-1.5 pl-3 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between flex-wrap">
          <div class="flex-1 flex items-center text-black">
            <span class="flex p-2 rounded-lg bg-yellow-600">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M2 5a2 2 0 012-2h12a2 2 0 012 2v10a2 2 0 01-2 2H4a2 2 0 01-2-2V5zm3.293 1.293a1 1 0 011.414 0l3 3a1 1 0 010 1.414l-3 3a1 1 0 01-1.414-1.414L7.586 10 5.293 7.707a1 1 0 010-1.414zM11 12a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" />
              </svg>
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
