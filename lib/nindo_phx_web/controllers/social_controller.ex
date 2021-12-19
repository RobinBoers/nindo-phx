defmodule NindoPhxWeb.SocialController do
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, RSS, Feeds, Comments}
  alias NindoPhxWeb.{Endpoint, Live}
  import NindoPhxWeb.{Router.Helpers}

  import Nindo.Core

  # Pages to display

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end

  def app(conn, _params) do
    case logged_in?(conn) do
      true ->
        conn
        |> put_session(:app, true)
        |> redirect(to: live_path(Endpoint, Live.Social))
      false ->
        conn
        |> put_session(:app, true)
        |> put_layout(false)
        |> put_root_layout("base.html")
        |> render("app.html")
    end
  end

  # Feeds and users

  def post(conn, %{"id" => id}) do
    conn
    |> assign(:error, get_session(conn, :error))
    |> put_session(:error, nil)
    |> render("post.html", post: Nindo.Posts.get(id), rss: false)
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

  def external_feed(conn, %{"source" => input}) do
    [url, type] = String.split(input, ":")

    feed = Feeds.get_feed(url)
    source = RSS.generate_source(feed, type, url)

    posts = RSS.generate_posts(feed, source)

    render(conn, "feed.html", posts: posts, title: feed["title"])
  end

  def external_post(conn, %{"url" => url, "title" => title, "datetime" => datetime}) do
    datetime = from_string(datetime)
    post = Feeds.get_post(url, title, datetime)

    render(conn, "post.html", post: post, rss: true)
  end

  # Posts and comments

  def new_comment(conn, params) do
    title = params["comment"]["title"]
    body = params["comment"]["body"]
    post_id = params["comment"]["post_id"]

    redirect_to =
      NavigationHistory.last_path(conn,
      default: live_path(Endpoint, Live.Social))

    case Comments.new(post_id, title, body, user(conn)) do
      {:ok, _comment}    ->
        redirect(conn, to: redirect_to)
      {:error, error} ->
        conn
        |> put_session(:error, format_error(error))
        |> redirect(to: redirect_to)
    end
  end

end
