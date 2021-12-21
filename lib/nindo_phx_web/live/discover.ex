defmodule NindoPhxWeb.Live.Discover do
  @moduledoc """
  LiveView for displaying the a list of user profiles and searching them.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{Endpoint, SocialView, Live}

  alias Nindo.{Accounts}

  import Routes
  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign(:logged_in?, logged_in?(session))
    |> assign(:user, user(session))}
  end

  @impl true
  def handle_params(%{"query" => query}, _uri, socket) do
    results = Accounts.search(query)

    {:noreply, socket
    |> assign(:page_title, "Search results for \"#{query}\"")
    |> assign(:users, results)
    |> assign(:searching, true)
    |> assign(:query, query)}
  end

  def handle_params(_params, _uri, socket) do
    users = get_users(6)

    {:noreply, socket
    |> assign(:page_title, "Discover")
    |> assign(:users, users)
    |> assign(:searching, false)
    |> assign(:query, nil)}
  end

  @impl true
  def render(assigns), do: render SocialView, "discover.html", assigns

  @impl true
  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    {:noreply, push_patch(socket, to: live_path(Endpoint, Live.Discover))}
  end
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    {:noreply, push_patch(socket, to: live_path(Endpoint, Live.Discover, query))}
  end

  def handle_event("search", _params, socket), do: {:noreply, push_patch(socket, to: live_path(Endpoint, Live.Discover))}

  defp get_users(count) do
    count
    |> Accounts.list()
    #|> Enum.shuffle() # shuffle to make a random order
  end
end
