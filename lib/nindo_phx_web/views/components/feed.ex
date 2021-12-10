defmodule NindoPhxWeb.FeedComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.{SocialView, PostComponent}

  import Nindo.Core

  def mixed(assigns) do
    posts =
      assigns.users
      |> Enum.flat_map(fn user -> SocialView.get_posts(user) end)
      |> Enum.sort_by(&(&1.datetime), {:desc, NaiveDateTime})

    feed %{posts: posts, user_link: assigns.user_link, rss: false, preview: false, conn: assigns.conn}
  end

  def feed(assigns) when assigns.posts == [] do
    ~H"""
      <p class="inactive">Wow, such empty...</p>
    """
  end
  def feed(assigns) do
    ~H"""
      <%= for post <- @posts do %>
        <%= if @preview do %>
          <PostComponent.preview post={post} user_link={@user_link} rss={post[:type] != nil} conn={@conn} />
        <% else %>
          <PostComponent.default post={post} user_link={@user_link} rss={post[:type] != nil} />
        <% end %>
      <% end %>
    """
  end

  def customizer(assigns) do
    ~H"""
      <div class="w-full flex-grow-0 rounded-md text-black">
          <div class="pt-4">
            <%= form_for(@conn, social_path(@conn, :add_feed), [as: :add_feed, method: :put, class: "w-full flex flex-row"], fn f -> %>
              <span class="input input-l input-static">https://</span>
              <%= text_input f, :feed, autofocus: "autofocus", placeholder: "Add RSS feed...", class: "input input-m flex-grow w-full text-black" %>
              <%= select f, :type, ["Blogger": :blogger, "Wordpress": :wordpress, "YouTube": :youtube, "Atom": :atom, "Custom": :custom], class: "input input-r"  %>
            <% end) %>
          </div>

          <%= if @feeds != [] do %>
                <h3 class="heading pt-4">Sources</h3>
          <% end %>

          <ul>

              <%= for feed <- @feeds do %>

                <li class="p-2 py-3 flex flex-row flex-wrap center-items">
                  <%= if feed["icon"] != nil do %>
                    <img class="w-8 mr-3" src={feed["icon"]} onerror="this.src='/images/rss.png'">
                  <% else %>
                    <span class="w-8 mr-3"></span>
                  <% end %>
                  <span class="mt-1">
                    <a href={get_source_link(feed)}><%= feed["title"] %></a>
                  </span>

                  <%= link safe("<i class='fas fa-times'></i>"), to: social_path(@conn, :remove_feed, feed: feed), method: :delete, class: "mt-2 no-underline ml-auto hover:bg-gray-200 w-auto px-2 rounded-full" %>
                </li>

              <% end %>
          </ul>
      </div>
    """
  end

  # Helper methods

  def get_source_link(feed) do
    "/source/#{URI.encode(feed["feed"], &(&1 != ?/ and &1 != ?: and &1 != ??))}:#{feed["type"]}"
  end

end
