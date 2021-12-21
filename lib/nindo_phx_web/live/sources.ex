defmodule NindoPhxWeb.Live.Sources do
  @moduledoc """
  LiveView for managing sources and followed users.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{Endpoint, SocialView}

  alias Nindo.{Accounts, Feeds}

  import Routes
  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    case logged_in?(session) do
      true -> {:ok, socket
      |> assign(:page_title, "Sources")
      |> assign(:logged_in, logged_in?(session))
      |> assign(:user, user(session))}

      _    -> {:ok, redirect(socket, to: account_path(Endpoint, :sign_in))}
    end

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
