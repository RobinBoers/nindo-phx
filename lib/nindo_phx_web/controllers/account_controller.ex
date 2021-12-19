defmodule NindoPhxWeb.AccountController do
  use NindoPhxWeb, :controller

  alias Nindo.{Accounts, Feeds}
  import NindoPhxWeb.{Router.Helpers}

  alias NindoPhxWeb.{Endpoint, Live}

  import Nindo.Core

  plug :scrub_params, "prefs" when action in [:update_prefs, :update_profile_picture]

  # Pages to display

  def sign_up(conn, _params) do
    render(conn, "sign_up.html")
  end
  def sign_in(conn, _params) do
    render(conn, "sign_in.html")
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
          |> put_session(:logged_in, true)
          |> put_session(:user_id, id)
          |> redirect(to: redirect_to)

        :wrong_password   ->    render(conn, "sign_in.html", error: %{title: "password", message: "Doesn't match"})
        _                 ->    render(conn, "sign_in.html", error: %{title: "error", message: "Something went wrong"})
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
    |> put_session(:logged_in, false)
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
        |> put_session(:logged_in, true)
        |> put_session(:user_id, account.id)
        |> redirect(to: social_path(Endpoint, :welcome))
      {:error, error}   ->    render(conn, "sign_up.html", error: format_error(error))
    end
  end
end
