defmodule NindoPhxWeb.FeedComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.SocialView
  alias NindoPhxWeb.PostComponent

  import Nindo.Core

  def single(assigns), do:
    feed %{posts: SocialView.get_posts(assigns.username), user_link: assigns.user_link, rss: false}

  def mixed(assigns) do
    posts =
      assigns.users
      |> Enum.flat_map(fn user -> SocialView.get_posts(user) end)
      |> Enum.sort_by(&(&1.datetime), {:desc, NaiveDateTime})

    feed %{posts: posts, user_link: assigns.user_link, rss: false}
  end

  def rss(assigns) do
    posts =
      :username
      |> Nindo.Accounts.get_by(assigns.username)
      |> Nindo.FeedAgent.get_pid()
      |> Nindo.FeedAgent.get_posts()

    feed %{posts: posts, user_link: false, rss: true}
  end

  def feed(assigns) when assigns.posts == [] do
    ~H"""
      <p class="my-6 text-gray-500">Wow, such empty...</p>
    """
  end
  def feed(assigns) do
    ~H"""
      <%= for post <- @posts do %>
        <PostComponent.show post={post} user_link={@user_link} rss={@rss} />
      <% end %>
    """
  end

  def customizer(assigns) do
    ~H"""
      <div class="w-full flex-grow-0 min-h-md rounded shadow bg-white text-black">
          <div class="pt-4 p-3">
            <%= form_for(@conn, rss_path(@conn, :add_feed), [as: :add_feed, method: :put, class: "w-full flex flex-row"], fn f -> %>
              <span class="input input-l input-static">https://</span>
              <%= text_input f, :feed, autofocus: "autofocus", placeholder: "Add RSS feed...", class: "input input-m flex-grow text-black" %>
              <%= select f, :type, ["Blogger": :blogger, "Wordpress": :wordpress, "Custom": :custom], class: "input input-r"  %>
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
                    <a href={"/rss/#{URI.parse(feed["feed"]).authority}:#{feed["type"]}"}><%= feed["title"] %></a>
                  </span>

                  <%= link safe("<i class='fas fa-times'></i>"), to: rss_path(@conn, :remove_feed, feed: feed), method: :delete, class: "mt-2 no-underline ml-auto hover:bg-gray-200 w-auto px-2 rounded-full" %>
                </li>

              <% end %>
          </ul>
      </div>
    """
  end

end
