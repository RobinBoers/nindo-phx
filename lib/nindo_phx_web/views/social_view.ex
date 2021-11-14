defmodule NindoPhxWeb.SocialView do
  @moduledoc false

  use NindoPhxWeb, :view

  alias Nindo.{Accounts, Posts, Format}
  alias NindoPhxWeb.{ProfileComponent, FeedComponent, AlertComponent, PostComponent, UIComponent}

  import Nindo.Core

  # Post feed

  def get_posts(username) do
    account = Accounts.get_by(:username, username)
    Posts.get(:user, account.id)
    |> Enum.map(fn post ->
      Map.from_struct(post)
    end)
    |> Enum.reverse() # reverse because otherwise the newest post will be at the bottom in EEx
  end

  # Discover page

  def get_users() do
    Accounts.list(6)
    |> Enum.shuffle() # shuffle to make a random order
  end
end
