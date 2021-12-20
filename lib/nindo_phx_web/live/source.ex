defmodule NindoPhxWeb.Live.Source do
  @moduledoc """
  LiveView to display the posts of an external RSS feed.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{SocialView}

  alias Nindo.{Feeds, RSS}

  import Nindo.Core

  @impl true
  def mount(%{"source" => input}, session, socket) do
    [url, type] = String.split(input, ":")

    feed =
      url
      |> URI.decode()
      |> Feeds.get_feed()
    source = RSS.generate_source(feed, type, url)

    posts = RSS.generate_posts(feed, source)

    {:ok, socket
    |> assign(:logged_in, logged_in?(session))
    |> assign(:user, user(session))
    |> assign(:page_title, feed["title"])
    |> assign(:posts, posts)
    |> assign(:title, feed["title"])}
  end

  @impl true
  def render(assigns), do: render SocialView, "feed.html", assigns
end
