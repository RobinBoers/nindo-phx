defmodule NindoPhxWeb.RSSController do
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, RSS, Feeds, FeedAgent}
  import NindoPhxWeb.{Router.Helpers}

  import Nindo.Core

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
    {source, _} = RSS.detect_feed(type, source)
    feed = RSS.parse_feed(source)
    posts = RSS.generate_posts(feed)

    render(conn, "external.html", posts: posts, title: feed["title"])
  end

  # Manage feeds

  def add_feed(conn, params) do
    {source, pull} = RSS.detect_feed(params["add_feed"]["type"], params["add_feed"]["feed"])

    case RSS.parse_feed(pull) do
      {:error, _} ->
        conn
        |> put_session(:error, %{title: "uri", message: "Invalid feed"})
        |> redirect(to: rss_path(conn, :sources))
      feed ->
        if logged_in?(conn) do
          Feeds.add(
            %{
              "title" => feed["title"],
              "feed" => source,
              "type" => params["add_feed"]["type"],
              "icon" => RSS.detect_favicon(URI.parse(source).authority)
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

end
