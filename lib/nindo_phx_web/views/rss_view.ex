defmodule NindoPhxWeb.RSSView do
  @moduledoc false

  use NindoPhxWeb, :view
  import NindoPhxWeb.ViewHelpers
  alias NindoPhxWeb.SocialHelpers
  alias NindoPhxWeb.{FeedComponent}

  # RSS feeds

  #todo(robin): move this to RSSComponent. doesnt work for some reason. says that the function doesnt exist. maybe because the rss feeds use .eex instead of .heex? dunno

  def generate_feed(username) do
    account = Nindo.Accounts.get_by(:username, username)
    channel = RSS.channel("#{SocialHelpers.display_name(username)}'s feed · Nindo", "https://nindo.net/user/#{username}", account.description, to_rfc822(Nindo.Core.datetime()), "en-us")

    items =
      :user
      |> Nindo.Posts.get(account.id)
      |> Enum.map(fn post ->
        RSS.item(post.title, post.body, to_rfc822(post.datetime), "https://nindo.net/post/#{post.id}", "https://nindo.net/post/#{post.id}")
      end)

    RSS.feed(channel, items)
  end

end
