defmodule NindoPhxWeb.SocialController do
  use NindoPhxWeb, :controller

  alias Nindo.{Comments}
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
