defmodule NindoPhxWeb.SocialController do
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, RSS, Feeds, FeedAgent, RSS.YouTube}
  import NindoPhxWeb.{Router.Helpers}

  import Nindo.Core

  # Pages to display

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

  def discover(conn, _params) do
    render(conn, "discover.html")
  end

  def sources(conn, _params) do
    conn
    |> assign(:error, get_session(conn, :error))
    |> put_session(:error, nil)
    |> render("sources.html")
  end

  # Feeds and users

  def user(conn, %{"username" => username}) do
    render(conn, "user.html", username: username)
  end

  def post(conn, %{"id" => id}) do
    render(conn, "post.html", id: id, post: Nindo.Posts.get(id))
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

  def external(conn, %{"source" => input}) do
    [url, type] = String.split(input, ":")

    feed = RSS.parse_feed(url, type)
    source = RSS.generate_source(feed, type, url)

    posts = RSS.generate_posts(feed, source)

    render(conn, "external.html", posts: posts, title: feed["title"])
  end

  # Manage feeds and followers

  def add_feed(conn, params) do
    type = params["add_feed"]["type"]
    url = convert_link(type, params["add_feed"]["feed"])

    case RSS.parse_feed(url, type) do

      {:error, _} ->
        conn
        |> put_session(:error, %{title: "uri", message: "Feed doesn't exist or is invalid"})
        |> redirect(to: social_path(conn, :sources))

      feed ->
        if logged_in?(conn) do
          Feeds.add(RSS.generate_source(feed, type, url), user(conn))
        end

        redirect(conn, to: social_path(conn, :sources))
    end
  end

  def remove_feed(conn, params) do
    feed = params["feed"]

    if logged_in?(conn) do
      Feeds.remove(feed, user(conn))
    end

    redirect(conn, to: social_path(conn, :sources))
  end

  def follow(conn, %{"username" => person}) do
    if logged_in?(conn) do

      case person in user(conn).following do
        true  -> Feeds.unfollow(person, user(conn))
        _     -> Feeds.follow(person, user(conn))
      end

      redirect_to =
        NavigationHistory.last_path(conn, 1,
        default: social_path(conn, :user, person))

      redirect(conn, to: redirect_to)
    else
      redirect(conn, to: account_path(conn, :sign_in))
    end
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
