defmodule NindoPhxWeb.PageController do
  @moduledoc """
  Controller for rendering static pages and XML feeds.
  """
  use NindoPhxWeb, :controller
  alias NindoPhxWeb.{SocialView, ErrorView}
  @admins ["robin"]

  alias Nindo.{Accounts, Posts, Comments, RSS}

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Social media of the future")
    |> put_layout("page.html")
    |> render("index.html")
  end
  def about(conn, _params) do
    conn
    |> assign(:page_title, "About")
    |> put_layout("page.html")
    |> render("about.html")
  end
  def blog(conn, _params) do
    conn
    |> assign(:page_title, "Blog")
    |> assign(:authorized_users, @admins)
    |> put_layout("page.html")
    |> render("blog.html")
  end

  # Feeds and raw posts

  def post_feed(conn, %{"username" => username}) do
    account = Accounts.get_by(:username, username)

    if account != nil do
      channel = RSS.generate_channel(account)
      items = RSS.generate_entries(account)

      feed = RSS.generate_feed(channel, items)

      conn
      |> put_req_header("accept", "application/xml")
      |> render("feed.xml", feed: feed)
    else
      conn
      |> put_view(ErrorView)
      |> put_root_layout("base.html")
      |> assign(:page_title, "Oops!")
      |> render("404.html")
    end
  end

  def comment_feed(conn, %{"id" => id}) do
    post = Posts.get(id)

    if post != nil do
      channel = RSS.channel(
        "Nindo",
        "https://#{RSS.base_url()}/post/#{id}",
        "The official micro blog for Nindo."
      )
      items =
        :post
        |> Comments.get(id)
        |> Enum.reverse()
        |> Enum.map(&RSS.generate_entry(&1.title, &1.body, &1.datetime, id))

      feed = RSS.generate_feed(channel, items)

      conn
      |> put_req_header("accept", "application/xml")
      |> render("feed.xml", feed: feed)
    else
      conn
      |> put_view(ErrorView)
      |> put_root_layout("base.html")
      |> assign(:page_title, "Oops!")
      |> render("404.html")
    end
  end

  def blog_feed(conn, _params) do
    items =
      @admins
      |> Enum.flat_map(&SocialView.get_posts(&1))
      |> Enum.sort_by(&(&1.datetime), {:desc, NaiveDateTime})
      |> Enum.map(&RSS.generate_entry(&1.title, &1.body, &1.datetime, &1.id))

    channel = RSS.channel(
      "Nindo",
      "https://#{RSS.base_url()}/blog",
      "The official micro blog for Nindo."
    )

    feed = RSS.generate_feed(channel, items)

    conn
    |> put_req_header("accept", "application/xml")
    |> render("feed.xml", feed: feed)
  end

  def markdown(conn, %{"id" => id}) do
    post = Posts.get(id)
    case Posts.exists?(id) do
      true -> text(conn, "# #{post.title}\n\n#{post.body} ")
      false -> text(conn, "Post not found. ")
      _ -> text(conn, "Something went wrong. ")
    end
  end
end
