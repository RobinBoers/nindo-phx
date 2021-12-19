defmodule NindoPhxWeb.Live.User do
  @moduledoc """
  LiveView to display the posts of an user
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{SocialView}

  alias Nindo.{Accounts, Feeds}
  import Nindo.Core

  @impl true
  def mount(%{"username" => username}, session, socket) do
    {:ok, socket
    |> assign(:logged_in, logged_in?(session))
    |> assign(:user, user(session))
    |> assign(:username, username)}
  end

  @impl true
  def render(assigns), do: render SocialView, "user.html", assigns

  @impl true
  def handle_event("follow", %{"username" => username}, socket) do
    case username in socket.assigns.user.following do
      true  -> Feeds.unfollow(username, socket.assigns.user)
      _     -> Feeds.follow(username, socket.assigns.user)
    end

    user = Accounts.get(socket.assigns.user.id)

    {:noreply, socket
    |> assign(:user, user)}
  end
end
