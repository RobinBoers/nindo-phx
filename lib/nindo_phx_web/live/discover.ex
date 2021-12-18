defmodule NindoPhxWeb.Live.Discover do
  @moduledoc """
  LiveView for displaying the a list of user profiles and searching them.
  """
  use NindoPhxWeb, :live_view

  alias Nindo.{Accounts}
  alias NindoPhxWeb.{SocialView}

  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    users = get_users(6)

    {:ok, socket
    |> assign(:users, users)
    |> assign(:searching, false)
    |> assign(:logged_in, logged_in?(session))
    |> assign(:user, user(session))}
  end

  @impl true
  def render(assigns), do: render SocialView, "discover.html", assigns

  @impl true
  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    {:noreply, socket
    |> assign(:searching, false)}
  end
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    results = Accounts.search(query)

    {:noreply, socket
    |> assign(:users, results)
    |> assign(:searching, true)
    |> assign(:query, query)}
  end
  def handle_event("search", _params, socket), do: {:noreply, socket}

  defp get_users(count) do
    count
    |> Accounts.list()
    #|> Enum.shuffle() # shuffle to make a random order
  end
end
