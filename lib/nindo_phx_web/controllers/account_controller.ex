defmodule NindoPhxWeb.AccountController do
  use NindoPhxWeb, :controller

  import NindoPhxWeb.{Router.Helpers}
  alias Nindo.{Accounts, Auth}

  import Nindo.Core

  # Pages to display

  def sign_up(conn, _params) do
    render(conn, "sign_up.html")
  end
  def sign_in(conn, _params) do
    render(conn, "sign_in.html")
  end

  def index(conn, _params) do
    case logged_in?(conn) do
      true  -> render(conn, "index.html")
      _     -> redirect(conn, to: account_path(conn, :sign_in))
    end

  end

  # Session management

  def login(conn, params) do
    username = params["login"]["username"]
    password = params["login"]["password"]
    account  = Accounts.get_by(:username, username)

    if account != nil do
      id       = account.id

      case Accounts.login(username, password) do
        :ok ->
          conn
          |> put_session(:logged_in, true)
          |> put_session(:user_id, id)
          |> redirect(to: social_path(conn, :index))

        :wrong_password   ->    render(conn, "sign_in.html", error: %{title: "password", message: "Doesn't match"})
        _                 ->    render(conn, "sign_in.html", error: %{title: "error", message: "Something went wrong"})
      end
    else
      render(conn, "sign_in.html", error: %{title: "account", message: "Doesn't exist"})
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:logged_in, false)
    |> put_session(:user_id, nil)
    |> redirect(to: account_path(conn, :sign_in))
  end

  # Account managment

  def create_account(conn, params) do
    username = params["create_account"]["username"]
    password = params["create_account"]["password"]
    email = params["create_account"]["email"]
    profile_picture = "https://avatars.dicebear.com/api/identicon/#{username}.svg"

    case Accounts.new(username, password, email, profile_picture) do
      {:ok, _account}   ->    redirect(conn, to: account_path(conn, :sign_in))
      {:error, error}   ->    render(conn, "sign_up.html", error: format_error(error))
    end
  end

  def update_prefs(conn, params) do
    display_name = params["prefs"]["display_name"]
    email = params["prefs"]["email"]
    description = params["prefs"]["description"]

    if logged_in?(conn) do
      Accounts.change(:display_name, display_name, user(conn))
      Accounts.change(:email, email, user(conn))
      Accounts.change(:description, description, user(conn))

      redirect(conn, to: account_path(conn, :index))
    else
      render(conn, "index.html", error: %{title: "error", message: "Something went wrong"})
    end
  end

  def change_password(conn, params) do
    p1 = params["change_password"]["password"]
    p2 = params["change_password"]["check"]

    if p1 == p2 and logged_in?(conn) do
      salt = user(conn).salt
      password = Auth.hash_pass(p1, salt)

      Accounts.change(:password, password, user(conn))
      redirect(conn, to: account_path(conn, :index))
    else
      render(conn, "index.html", error: %{title: "passwords", message: "Don't match"})
    end
  end

  # Private methods

  defp format_error(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      %{title: "#{acc}#{k}", message: String.capitalize joined_errors}
    end)
  end

end
