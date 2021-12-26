defmodule NindoPhxWeb.Live.Source do
  @moduledoc """
  LiveView to display the posts of an external RSS feed.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{SocialView, Error}

  alias NinDB.{Source}
  alias Nindo.{Feeds, RSS}

  import Nindo.Core

  @impl true
  def mount(%{"source" => source_id}, session, socket) do
    case logged_in?(session) do
      true ->
        user = user(session)
        source = Enum.filter(user.sources, fn source = %Source{id: id} ->
          id == source_id
          source
        end)

        case source do
          [source] ->
            feed = Feeds.get_feed(source.feed)
            posts = RSS.generate_posts(feed, source)

            {:ok, socket
            |> assign(:logged_in?, true)
            |> assign(:user, user)
            |> assign(:page_title, feed["title"])
            |> assign(:posts, posts)
            |> assign(:title, feed["title"])}
          _ -> raise Error.NotFound
        end

      _ ->
        raise Error.NotFound
    end
  end

  @impl true
  def render(assigns), do: render SocialView, "feed.html", assigns
end
