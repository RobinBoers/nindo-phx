defmodule NindoPhxWeb.RSSController do
  use NindoPhxWeb, :controller

  import NindoPhxWeb.{Router.Helpers, ViewHelpers, RSSHelpers}

  def feed(conn, %{"username" => username}) do
    conn
    |> put_req_header("accept", "application/xml")
    |> render("feed.xml", username: username)
  end

  def external(conn, %{"source" => source}) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(detect_feed(source))
    {:ok, feed, _} = FeederEx.parse(body)

    posts = Enum.map(feed.entries, fn entry ->
      %{
        author: entry.author,
        body: safe(entry.summary),
        datetime: Nindo.Core.datetime(),
        image: entry.image,
        title: entry.title,
      }
    end)

    render(conn, "external.html", posts: posts, title: feed.title)
  end

  # Manage posts and feeds

  def add_feed(conn, params) do
    source = params["add_feed"]["feed"]
    source = detect_feed(source)

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(source)
    {:ok, feed, _} = FeederEx.parse(body)

    if logged_in?(conn) do
      Nindo.Feeds.add(%{"title" => feed.title, "feed" => source, "icon" => feed.image}, user(conn))
    end

    redirect(conn, to: social_path(conn, :discover))
  end

  def remove_feed(conn, params) do
    feed =
      params["feed"]
      |> Enum.map(fn
          {key, val} when val === "" -> {key, nil}
          {key, val} -> {key, val}
        end)
      |> Enum.into(%{})

    if logged_in?(conn) do
      Nindo.Feeds.remove(feed, user(conn))
    end

    redirect(conn, to: social_path(conn, :discover))
  end

end
