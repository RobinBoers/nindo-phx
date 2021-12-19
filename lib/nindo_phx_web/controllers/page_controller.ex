defmodule NindoPhxWeb.PageController do
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, RSS}

  def index(conn, _params) do
    render(conn, "index.html")
  end
  def about(conn, _params) do
    render(conn, "about.html")
  end
  def blog(conn, _params) do
    render(conn, "blog.html")
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
