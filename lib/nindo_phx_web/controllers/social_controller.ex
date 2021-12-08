defmodule NindoPhxWeb.SocialController do
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, Posts, RSS, Feeds, Comments, FeedAgent, RSS.YouTube}
  alias NindoPhxWeb.{AccountController, SocialView}
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

      conn
      |> assign(:error, get_session(conn, :error))
      |> put_session(:error, nil)
      |> render("index.html", posts: posts)
    else
        redirect(conn, to: social_path(conn, :discover))
    end
  end

  def discover(conn, _params) do
    render(conn, "discover.html", users: SocialView.get_users(6), searching: false)
  end

  def sources(conn, _params) do
    conn
    |> assign(:error, get_session(conn, :error))
    |> put_session(:error, nil)
    |> render("sources.html")
  end

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end

  def app(conn, _params) do
    case logged_in?(conn) do
      true -> redirect(conn, to: social_path(conn, :index))
      false ->
        conn
        |> put_layout(false)
        |> put_root_layout("base.html")
        |> render("app.html")
    end
  end

  # Searching

  def search(conn, %{"query" => ""}), do: redirect(conn, to: social_path(conn, :discover))
  def search(conn, %{"query" => query}) do
    results = Accounts.search(query)
    render(conn, "discover.html", users: results, searching: true, query: query)
  end

  # Feeds and users

  def user(conn, %{"username" => username}) do
    render(conn, "user.html", username: username)
  end

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

  def new_post(conn, params) do
    title = params["post"]["title"]
    body = params["post"]["body"]
    user = user(conn)

    redirect_to =
      NavigationHistory.last_path(conn,
      default: social_path(conn, :index))

    case Posts.new(title, body, nil, user) do
      {:ok, _post}    ->
        Feeds.update_cache(user)
        redirect(conn, to: redirect_to)
      {:error, error} ->
        conn
        |> put_session(:error, AccountController.format_error(error))
        |> redirect(to: redirect_to)
    end

  end

  def new_comment(conn, params) do
    title = params["comment"]["title"]
    body = params["comment"]["body"]
    post_id = params["comment"]["post_id"]

    redirect_to =
      NavigationHistory.last_path(conn,
      default: social_path(conn, :index))

    case Comments.new(post_id, title, body, user(conn)) do
      {:ok, _comment}    ->
        redirect(conn, to: redirect_to)
      {:error, error} ->
        conn
        |> put_session(:error, AccountController.format_error(error))
        |> redirect(to: redirect_to)
    end
  end

  # Manage feeds and followers

  def add_feed(conn, params) do
    type = params["add_feed"]["type"]
    url = convert_link(type, params["add_feed"]["feed"])

    redirect_to =
      NavigationHistory.last_path(conn,
      default: social_path(conn, :sources))

    case RSS.parse_feed(url, type) do

      {:error, _} ->
        conn
        |> put_session(:error, %{title: "uri", message: "Feed doesn't exist or is invalid"})
        |> redirect(to: social_path(conn, :sources))

      feed ->
        if logged_in?(conn) do
          Feeds.add(RSS.generate_source(feed, type, url), user(conn))
        end

        redirect(conn, to: redirect_to)
    end
  end

  def remove_feed(conn, params) do
    feed = params["feed"]

    if logged_in?(conn) do
      Feeds.remove(feed, user(conn))
    end

    redirect_to =
      NavigationHistory.last_path(conn,
      default: social_path(conn, :sources))

    redirect(conn, to: redirect_to)
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

  # Helper methods

  @doc """
  This method is used to convert the YouTube custom urls or legacy
  username to the yt.com/channel/id format, which is needed for the
  RSS feeds to work. Converting is a expensive task, which also uses quota
  on my YT API key. That's why I only convert it when adding the feed
  and not every time I need to access the feed.
  """
  def convert_link(type, feed) do
    case type do
      "youtube" -> YouTube.to_channel_link(feed)
      _         -> feed
    end
  end

end
