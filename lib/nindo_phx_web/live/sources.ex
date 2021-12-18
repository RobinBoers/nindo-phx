defmodule NindoPhxWeb.Live.Sources do
  @moduledoc """
  LiveView for managing sources and followed users.
  """
  use NindoPhxWeb, :live_view

  alias Nindo.{Accounts, Feeds}
  alias NindoPhxWeb.{SocialView}

  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign(:logged_in, logged_in?(session))
    |> assign(:user, user(session))}
  end

  @impl true
  def render(assigns), do: render SocialView, "sources.html", assigns

  @impl true
  def handle_event("unfollow", %{"user" => username}, socket) do
    Feeds.unfollow(username, socket.assigns.user)
    user = Accounts.get(socket.assigns.user.id)

    {:noreply, socket
    |> assign(:user, user)}
  end
end
