defmodule NindoPhxWeb.SocialView do
  @moduledoc false

  use NindoPhxWeb, :view

  alias Nindo.{Accounts, Posts, Format}
  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.Live.Components.{NewPost}
  alias NindoPhxWeb.{ProfileComponent, FeedComponent, AlertComponent, PostComponent, UIComponent}

  alias NindoPhxWeb.Endpoint

  import Nindo.Core

  # Post feed

  def get_posts(username) do
    account = Accounts.get_by(:username, username)
    Posts.get(:user, account.id)
    |> Enum.map(fn post ->
      Map.from_struct(post)
    end)
    |> Enum.sort_by(&(&1.datetime), {:desc, NaiveDateTime})
  end

  # Discover page

  def get_users(count) do
    count
    |> Accounts.list()
    #|> Enum.shuffle() # shuffle to make a random order
  end
end
