defmodule NindoPhxWeb.SocialView do
  @moduledoc false

  use NindoPhxWeb, :view

  alias NindoPhxWeb.{ProfileComponent, FeedComponent, PostComponent, UIComponent}
  alias Nindo.{Accounts, Posts, Format}

  # Post feed

  def get_posts(username) do
    account = Accounts.get_by(:username, username)
    Posts.get(:user, account.id)
    |> Enum.reverse() # reverse because otherwise the newest post will be at the bottom in EEx
  end

  # Discover page

  def get_users() do
    Accounts.list(6)
    |> Enum.shuffle() # shuffle to make a random order
  end
end
