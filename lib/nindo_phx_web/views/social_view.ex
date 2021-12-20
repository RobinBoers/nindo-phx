defmodule NindoPhxWeb.SocialView do
  @moduledoc false

  use NindoPhxWeb, :view
  alias NindoPhxWeb.{Endpoint, Live}

  alias Nindo.{Accounts, Posts, Format}

  alias NindoPhxWeb.Live.Components.{NewPost, FeedCustomizer, CommentForm}
  alias NindoPhxWeb.{FeedComponent, CommentComponent}

  import Routes
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

  def get_source_data(feed) do
    "#{URI.encode(feed["feed"], &(&1 != ?/ and &1 != ?: and &1 != ??))}:#{feed["type"]}"
  end

end
