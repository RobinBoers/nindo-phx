defmodule NindoPhxWeb.Live.Discover do
  @moduledoc """
  LiveView for displaying the a list of user profiles and searching them.
  """
  use NindoPhxWeb, :live_view

  alias Nindo.{Accounts, FeedAgent}
  alias NindoPhxWeb.{SocialView}

  import NindoPhxWeb.Router.Helpers
  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign(:users, get_users(6))
    |> assign(:searching, false)
    |> assign(:logged_in, logged_in?(session))
    |> assign(:user, user(session))}
  end

  @impl true
  def render(assigns), do: render SocialView, "discover.html", assigns

  @impl true
  def handle_info(:refresh, socket) do
    user = socket.assigns.user

    posts =
      user.id
      |> Accounts.get()
      |> FeedAgent.get_pid()
      |> FeedAgent.get_posts()

    {:noreply, socket
    |> assign(:posts, posts)}
  end

  def handle_info(_, socket), do: {:noreply, socket}

  defp get_users(count) do
    count
    |> Accounts.list()
    #|> Enum.shuffle() # shuffle to make a random order
  end
end
