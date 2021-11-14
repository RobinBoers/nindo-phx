defmodule NindoPhxWeb.RSSController do
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, RSS, Feeds, FeedAgent, RSS.YouTube}
  import NindoPhxWeb.{Router.Helpers}

  import Nindo.Core

  def index(conn, _params) do
    if logged_in?(conn) do
      posts =
        user(conn).id
        |> Accounts.get()
        |> FeedAgent.get_pid()
        |> FeedAgent.get_posts()

      render(conn, "index.html", posts: posts)
    else
        redirect(conn, to: social_path(conn, :discover))
    end
  end

  def sources(conn, _params) do
    conn
    |> assign(:error, get_session(conn, :error))
    |> put_session(:error, nil)
    |> render("sources.html")
  end

  def feed(conn, %{"username" => username}) do
    account = Accounts.get_by(:username, username)

    channel = RSS.generate_channel(account)
    items = RSS.generate_entries(account)

    feed = RSS.generate_feed(channel, items)

    conn
    |> put_req_header("accept", "application/xml")
    |> render("feed.xml", feed: feed)
  end

  def external(conn, %{"source" => source}) do
    [source, type] = String.split(source, ":")
    source = RSS.detect_feed(type, URI.decode(source))

    feed = RSS.parse_feed(source)
    posts = RSS.generate_posts(feed, type)

    render(conn, "external.html", posts: posts, title: feed["title"])
  end

  # Manage feeds

  def add_feed(conn, params) do
    type = params["add_feed"]["type"]
    input_feed = convert_link(type, params["add_feed"]["feed"])

    source = RSS.detect_feed(type, input_feed)

    case RSS.parse_feed(source) do

      {:error, _} ->
        conn
        |> put_session(:error, %{title: "uri", message: "Feed doesn't exist or is invalid"})
        |> redirect(to: rss_path(conn, :sources))

      feed ->
        if logged_in?(conn) do

          Feeds.add(
            %{
              "title" => feed["title"],
              "feed" => input_feed,
              "type" => type,
              "icon" => RSS.detect_favicon(
                URI.parse("https://" <> input_feed).authority
              )
            }, user(conn)
          )

          user(conn)
          |> FeedAgent.get_pid()
          |> FeedAgent.update()

        end

        redirect(conn, to: rss_path(conn, :sources))
    end
  end

  def remove_feed(conn, params) do
    feed = params["feed"]

    if logged_in?(conn) do
      Feeds.remove(feed, user(conn))

      user(conn)
      |> FeedAgent.get_pid()
      |> FeedAgent.update()
    end

    redirect(conn, to: rss_path(conn, :sources))
  end

  # Private methods

  # This method is used to convert the YouTube custom urls or legacy
  # username to the yt.com/channel/id format, which is needed for the
  # RSS feeds to work. Converting is a expensive task, which also uses quota
  # on my YT API key. That's why I only convert it when adding the feed
  # and not every time I need to access the feed.
  defp convert_link(type, feed) do
    case type do
      "youtube" -> YouTube.to_channel_link(feed)
      _         -> feed
    end
  end

end
