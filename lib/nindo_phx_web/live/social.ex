defmodule NindoPhxWeb.Live.Social do
  @moduledoc """
  LiveView for displaying the user feed and publishing new posts.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{Endpoint, SocialView, Live}

  alias Nindo.{Accounts, FeedAgent}

  import Routes
  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    case logged_in?(session) do
      true ->
        posts =
          user(session).id
          |> Accounts.get()
          |> FeedAgent.get_pid()
          |> FeedAgent.get_posts()

          {:ok, socket
          |> assign(:posts, posts)
          |> assign(:page_title, "Social")
          |> assign(:logged_in?, logged_in?(session))
          |> assign(:user, user(session))}

      _ ->
      {:ok, socket
      |> redirect(to: live_path(Endpoint, Live.Discover))}
    end
  end

  @impl true
  def render(assigns), do: render SocialView, "index.html", assigns

  @impl true
  def handle_info(:refresh, socket) do
    user = socket.assigns.user

    posts =
      user.id
      |> Accounts.get()
      |> FeedAgent.get_pid()
      |> FeedAgent.get_posts()

    {:noreply, assign(socket, posts: posts)}
  end

  def handle_info(_, socket), do: {:noreply, socket}
end
