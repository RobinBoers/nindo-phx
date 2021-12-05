defmodule NindoPhxWeb.APIController do
  @moduledoc false
  use NindoPhxWeb, :controller
  plug :authenticate_api_user when action in [:change_account, :get_post]

  alias NindoPhxWeb.API.Auth
  alias Nindo.{Accounts, Posts}

  def list_accounts(conn, %{"limit" => limit}),
    do: json(conn, Accounts.list(limit))

  def list_accounts(conn, _params),
    do: json(conn, Accounts.list(:infinity))

  def create_account(conn, %{"username" => username, "password" => password, "email" => email}) do
    case Accounts.new(username, password, email) do
      {:ok, _account} ->
        conn
        |> put_status(:created)
        |> json(%{"message" => "Success! You can close this tab now."})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{"message" => "Error: something went wrong."})
    end
  end

  def get_account(conn, %{"username" => username}) do
    case Accounts.get_by(:username, username) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(nil)
      account -> json(conn, account)
    end
  end

  def change_account(conn, %{"key" => key, "value" => value}) do
    user = Accounts.get(conn.assigns.user_id)

    case Accounts.change(key, value, user) do
      {:ok, _account} ->
        conn
        |> put_status(:created)
        |> json(%{"message" => "Success! You can close this tab now."})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{"message" => "Success! You can close this tab now."})
    end
  end

  def list_posts(conn, %{"limit" => limit}),
    do: json(conn, Posts.get(:latest, limit))

  def list_posts(conn, _params),
    do: json(conn, Posts.get(:latest, 50))

  def new_post(conn, %{"title" => title, "body" => body}) do
    user = Accounts.get(conn.assigns.user_id)

    case Posts.new(title, body, nil, user) do
      {:ok, _post} ->
        conn
        |> put_status(:created)
        |> json(%{"message" => "Success! You can close this tab now."})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{"message" => "Success! You can close this tab now."})
    end
  end

  def get_post(conn, %{"id" => id}),
    do: json(conn, Posts.get(id))

  def login(conn, %{"username" => username, "password" => password}) do
    case Accounts.login(username, password) do
      :ok ->
        account = Nindo.Accounts.get_by(:username, username)
        json(conn, %{"token" => Auth.generate_token(account.id)})
      :wrong_password ->
        json(conn, %{"message" => "Wrong password."})
      :no_user_found ->
        json(conn, %{"message" => "Account doesn't exist."})
    end
  end
end
