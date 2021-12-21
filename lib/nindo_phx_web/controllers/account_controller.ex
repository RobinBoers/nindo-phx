defmodule NindoPhxWeb.AccountController do
  @moduledoc """
  Controller for managing the session.
  """
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, Feeds}
  import NindoPhxWeb.{Router.Helpers}

  alias NindoPhxWeb.{Endpoint, Live}

  import Nindo.Core

  # Pages to display

  def sign_up(conn, _params) do
    conn
    |> assign(:page_title, "Sign up")
    |> render("sign_up.html")
  end
  def sign_in(conn, _params) do
    conn
    |> assign(:page_title, "Sign in")
    |> render("sign_in.html")
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
        |> assign(:page_title, "Nindo")
        |> render("app.html")
    end
  end

  # Session management

  def login(conn, params) do
    username = params["username"]
    password = params["password"]
    account  = Accounts.get_by(:username, username)

    if account != nil do
      id = account.id

      redirect_to =
        case NavigationHistory.last_path(conn, 1,
        default: live_path(Endpoint, Live.Social)) do
          "/" -> live_path(Endpoint, Live.Social)
          path -> path
        end

      case Accounts.login(username, password) do
        :ok ->
          Feeds.cache(account)
          conn
          |> put_session(:logged_in?, true)
          |> put_session(:user_id, id)
          |> redirect(to: redirect_to)

        :wrong_password   ->
          conn
          |> put_flash(:error, "Password doesn't match")
          |> assign(:page_title, "Sign in")
          |> render("sign_in.html")

        _ ->
          conn
          |> put_flash(:error, "Something went wrong")
          |> assign(:page_title, "Sign in")
          |> render("sign_in.html")
      end
    else
      render(conn, "sign_in.html", error: %{title: "account", message: "Doesn't exist"})
    end
  end

  def logout(conn, _params) do
    redirect_to =
      NavigationHistory.last_path(conn, 1,
      default: account_path(Endpoint, :sign_in))

    conn
    |> put_session(:app, false)
    |> put_session(:logged_in?, false)
    |> put_session(:user_id, nil)
    |> redirect(to: redirect_to)
  end

  # Account managment

  def create_account(conn, params) do
    username = params["create_account"]["username"]
    password = params["create_account"]["password"]
    email = params["create_account"]["email"]

    case Accounts.new(username, password, email) do
      {:ok, account}    ->
        Feeds.follow(account.username, account)
        Feeds.cache(account)

        conn
        |> put_session(:logged_in?, true)
        |> put_session(:user_id, account.id)
        |> redirect(to: live_path(Endpoint, Live.Welcome))
      {:error, error}   ->
        conn
        |> put_flash(:error, format_error(error))
        |> assign(:page_title, "Sign up")
        |> render("sign_up.html")
    end
  end
end
