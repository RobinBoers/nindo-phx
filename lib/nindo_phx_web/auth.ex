defmodule NindoPhxWeb.API.Auth do
  @moduledoc """
  A module plug that verifies the bearer token in the request headers and
  assigns `:current_user`. The authorization header value may look like
  `Bearer xxxxxxx`.

  Totally not copied from <https://dev.to/mnishiguchi/simple-token-authentication-for-phoenix-json-api-1m05> or something :P
  """

  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_token()
    |> verify_token()
    |> case do
      {:ok, user_id} -> assign(conn, :current_user, user_id)
      _unauthorized -> assign(conn, :current_user, nil)
    end
  end

  @doc """
  A function plug that ensures that `:current_user` value is present.

  ## Examples

      # in a router pipeline
      pipe_through [:api, :authenticate_api_user]

      # in a controller
      plug :authenticate_api_user when action in [:index, :create]

  """
  def authenticate_api_user(conn, _opts) do
    if Map.get(conn.assigns, :current_user) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(NindoPhxWeb.ErrorView)
      |> render(:"401")
      # Stop any downstream transformations.
      |> halt()
    end
  end

  @doc """
  Generate a new token for a user id.

  ## Examples

      iex> NindoPhxWeb.API.Auth.generate_token(123)
      "xxxxxxx"

  """
  def generate_token(user_id) do
    Phoenix.Token.sign(
      NindoPhxWeb.Endpoint,
      inspect(__MODULE__),
      user_id
    )
  end

  @doc """
  Verify a user token.

  ## Examples

      iex> NindoPhxWeb.API.Auth.verify_token("good-token")
      {:ok, 1}

      iex> NindoPhxWeb.API.Auth.verify_token("bad-token")
      {:error, :invalid}

      iex> NindoPhxWeb.API.Auth.verify_token("old-token")
      {:error, :expired}

      iex> NindoPhxWeb.API.Auth.verify_token(nil)
      {:error, :missing}

  """
  @spec verify_token(nil | binary) :: {:error, :expired | :invalid | :missing} | {:ok, any}
  def verify_token(token) do
    one_month = 30 * 24 * 60 * 60

    Phoenix.Token.verify(
      NindoPhxWeb.Endpoint,
      inspect(__MODULE__),
      token,
      max_age: one_month
    )
  end

  @spec get_token(Plug.Conn.t()) :: nil | binary
  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end
end
