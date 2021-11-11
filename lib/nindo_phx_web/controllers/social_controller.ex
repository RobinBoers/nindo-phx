defmodule NindoPhxWeb.SocialController do
  use NindoPhxWeb, :controller

  import Nindo.Core

  # Pages to display

  def index(conn, _params) do
    if logged_in?(conn) do
      sources = for feed <- user(conn).feeds do
        feed["feed"]
      end
      render(conn, "index.html", sources: sources)
    else
      render(conn, "index.html", sources: [])
    end
  end

  def discover(conn, _params) do
    render(conn, "discover.html")
  end

  def user(conn, %{"username" => username}) do
    render(conn, "user.html", username: username)
  end

  def post(conn, %{"id" => id}) do
    render(conn, "post.html", id: id, post: Nindo.Posts.get(id))
  end

end
