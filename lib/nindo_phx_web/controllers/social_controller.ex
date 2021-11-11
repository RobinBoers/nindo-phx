defmodule NindoPhxWeb.SocialController do
  use NindoPhxWeb, :controller

  # Pages to display

  def discover(conn, _params) do
    render(conn, "discover.html")
  end

  def user(conn, %{"username" => username}) do
    render(conn, "user.html", username: username)
  end

  def post(conn, %{"id" => id}) do
    render(conn, "post.html", id: id)
  end

end
