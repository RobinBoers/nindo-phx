defmodule NindoPhxWeb.RSSComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  import NindoPhxWeb.{Router.Helpers, ViewHelpers}
  alias NindoPhxWeb.{SocialHelpers}

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

  def customizer(assigns) do
    ~H"""
      <div class="w-full flex-grow-0 min-h-md rounded shadow bg-white text-black">
          <div class="pt-4 p-3">
            <%= form_for(@conn, rss_path(@conn, :add_feed), [as: :add_feed, method: :put, class: "w-full flex flex-row"], fn f -> %>
              <%= text_input f, :feed, autofocus: "autofocus", placeholder: "Add RSS feed...", class: "input w-full text-black" %>
            <% end) %>
          </div>
          <hr class="clear-both">

          <ul class="p-4">
              <%= for feed <- @feeds do %>

                <li class="p-2 py-3 flex flex-row flex-wrap center-items">
                  <%= if feed["icon"] != nil do %>
                    <img src={feed["icon"]} class="w-8 mr-3">
                  <% else %>
                    <span class="w-8 mr-3"></span>
                  <% end %>
                  <span class="mt-1">
                    <a href={"/rss/#{URI.parse(feed["feed"]).authority}"}><%= feed["title"] %></a>
                  </span>

                  <%= link safe("<i class='fas fa-times'></i>"), to: rss_path(@conn, :remove_feed, feed: feed), method: :delete, class: "mt-2 no-underline ml-auto hover:bg-gray-200 w-auto px-2 rounded-full" %>
                </li>

              <% end %>
          </ul>
      </div>
    """
  end

end
