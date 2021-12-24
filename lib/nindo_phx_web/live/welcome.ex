defmodule NindoPhxWeb.Live.Welcome do
  @moduledoc """
  LiveView to display the welcome screen when a user first joins Nindo.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{SocialView}

  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign(:page_title, "Welcome")
    |> assign(:logged_in?, logged_in?(session))
    |> assign(:user, user(session))}
  end

  @impl true
  def render(assigns), do: render SocialView, "welcome.html", assigns

  @impl true
  def handle_info(:invalid_feed, socket) do
    {:noreply, put_flash(socket, :error, "Invalid feed")}
  end
end
