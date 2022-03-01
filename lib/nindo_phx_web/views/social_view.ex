defmodule NindoPhxWeb.SocialView do
  @moduledoc false

  use NindoPhxWeb, :view
  alias NindoPhxWeb.{Endpoint, Live}

  alias Nindo.{Accounts, Posts, Format, RSS.YouTube}

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
    |> Enum.sort_by(& &1.datetime, {:desc, NaiveDateTime})
  end

  # Font preference

  defp next_font("font-sans"), do: "font-serif"
  defp next_font("font-serif"), do: "font-display"
  defp next_font("font-display"), do: "font-mono"
  defp next_font("font-mono"), do: "font-sans"
end
