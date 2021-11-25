defmodule NindoPhxWeb.PageController do
  use NindoPhxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
  def about(conn, _params) do
    render(conn, "about.html")
  end
  def blog(conn, _params) do
    render(conn, "blog.html")
  end
end
