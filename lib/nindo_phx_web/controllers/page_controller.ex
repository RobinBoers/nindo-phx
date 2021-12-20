defmodule NindoPhxWeb.PageController do
  @moduledoc """
  Controller for rendering static pages and XML feeds.
  """
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, RSS}

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
    |> put_layout("page.html")
    |> render("blog.html")
  end

  # Feeds and users

  def feed(conn, %{"username" => username}) do
    account = Accounts.get_by(:username, username)

    channel = RSS.generate_channel(account)
    items = RSS.generate_entries(account)

    feed = RSS.generate_feed(channel, items)

    conn
    |> put_req_header("accept", "application/xml")
    |> render("feed.xml", feed: feed)
  end
end
