defmodule NindoPhxWeb.APIController do
  @moduledoc false
  use NindoPhxWeb, :controller

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

  def change_account(conn, %{"username" => username, "key" => key, "value" => value}) do
    user = Accounts.get_by(:username, username)

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

  def new_post(conn, %{"title" => title, "body" => body, "username" => username}) do
    user = Accounts.get_by(:username, username)

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
end
