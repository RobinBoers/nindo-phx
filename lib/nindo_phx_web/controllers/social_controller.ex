defmodule NindoPhxWeb.SocialController do
  use NindoPhxWeb, :controller

  alias Nindo.{Feeds}
  import NindoPhxWeb.{Router.Helpers}

  import Nindo.Core

  # Pages to display

  def discover(conn, _params) do
    render(conn, "discover.html")
  end

  def user(conn, %{"username" => username}) do
    render(conn, "user.html", username: username)
  end

  def post(conn, %{"id" => id}) do
    render(conn, "post.html", id: id, post: Nindo.Posts.get(id))
  end

  # Follow users

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

end
