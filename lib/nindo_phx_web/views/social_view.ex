defmodule NindoPhxWeb.SocialView do
  @moduledoc false

  use NindoPhxWeb, :view

  alias Nindo.{Accounts, Posts, Format}
  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.Live.Components.{NewPost, FeedCustomizer}
  alias NindoPhxWeb.{FeedComponent, AlertComponent, CommentComponent, UIComponent, Live}

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

  def get_source_link(feed) do
    "/source/#{URI.encode(feed["feed"], &(&1 != ?/ and &1 != ?: and &1 != ??))}:#{feed["type"]}"
  end

end
