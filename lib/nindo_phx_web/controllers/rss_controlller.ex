defmodule NindoPhxWeb.RSSController do
  use NindoPhxWeb, :controller

  alias Nindo.{RSS, Feeds}
  import NindoPhxWeb.{Router.Helpers}

  import Nindo.Core

  def sources(conn, _params) do
    render(conn, "sources.html")
  end

  def feed(conn, %{"username" => username}) do
    conn
    |> put_req_header("accept", "application/xml")
    |> render("feed.xml", username: username)
  end

  def external(conn, %{"source" => source}) do
    source = RSS.detect_feed(source)
    feed = RSS.parse_feed(source)
    posts = RSS.generate_posts(feed)

    render(conn, "external.html", posts: posts, title: feed.title)
  end

  # Manage posts and feeds

  def add_feed(conn, params) do
    source = RSS.detect_feed(params["add_feed"]["feed"])
    feed = RSS.parse_feed(source)

    if logged_in?(conn) do
      Feeds.add(
        %{
          "title" => feed.title,
          "feed" => source <> "&max-results=3",
          "icon" => feed.image
        }, user(conn)
      )
    end

    redirect(conn, to: rss_path(conn, :sources))
  end

  def remove_feed(conn, params) do
    feed = params["feed"]

    if logged_in?(conn) do
      Feeds.remove(feed, user(conn))
    end

    redirect(conn, to: rss_path(conn, :sources))
  end

end
