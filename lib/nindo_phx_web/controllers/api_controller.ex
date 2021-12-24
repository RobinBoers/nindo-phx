defmodule NindoPhxWeb.APIController do
  @moduledoc """
  Controller for the REST API.
  """
  use NindoPhxWeb, :controller
  plug :authenticate_api_user when action in [:change_account, :new_post]

  alias NindoPhxWeb.API.Auth
  alias Nindo.{Accounts, Posts}

  @doc """
  See [API/List accounts](/nindo-phx/list-accounts.html)
  """
  def list_accounts(conn, %{"limit" => limit}),
    do: json(conn, Accounts.list(limit))

  def list_accounts(conn, _params),
    do: json(conn, Accounts.list(:infinity))

  @doc """
  See [API/Create account](/nindo-phx/create-account.html)
  """
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

  @doc """
  See [API/Get account](/nindo-phx/get-account.html)
  """
  def get_account(conn, %{"username" => username}) do
    case Accounts.get_by(:username, username) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(nil)
      account -> json(conn, account)
    end
  end

  @doc """
  See [API/Modify account](/nindo-phx/modify-account.html)
  """
  def change_account(conn, %{"key" => key, "value" => value}) do
    user = Accounts.get(conn.assigns.current_user)

    case Accounts.change(key, value, user) do
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

  @doc """
  See [API/List posts](/nindo-phx/list-posts.html)
  """
  def list_posts(conn, %{"limit" => limit}),
    do: json(conn, Posts.get(:latest, limit))

  def list_posts(conn, _params),
    do: json(conn, Posts.get(:latest, 50))

  @doc """
  See [API/New post](/nindo-phx/new-post.html)
  """
  def new_post(conn, %{"title" => title, "body" => body}) do
    user = Accounts.get(conn.assigns.current_user)

    case Posts.new(title, body, nil, user) do
      {:ok, _post} ->
        conn
        |> put_status(:created)
        |> json(%{"message" => "Success! You can close this tab now."})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{"message" => "Error: something went wrong."})
    end
  end

  @doc """
  See [API/Get post](/nindo-phx/get-post.html)
  """
  def get_post(conn, %{"id" => id}),
    do: json(conn, Posts.get(id))

  @doc """
  See [API/Authentication](/nindo-phx/login.html)
  """
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

  @doc """
  See [Markdown API](/nindo-phx/markdown-api.html)
  """
  def markdown(conn, %{"id" => id}) do
    post = Posts.get(id)
    case Posts.exists?(id) do
      true -> text(conn, "# #{post.title}\n\n#{post.body} ")
      false -> text(conn, "Post not found. ")
      _ -> text(conn, "Something went wrong. ")
    end
  end
end
