defmodule NindoPhxWeb.FeedComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias NindoPhxWeb.{SocialView, PostComponent}

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
          <PostComponent.preview post={post} user_link={@user_link} rss={post[:type] != nil} />
        <% else %>
          <PostComponent.default post={post} user_link={@user_link} rss={post[:type] != nil} />
        <% end %>
      <% end %>
    """
  end

  # Helper methods

  def get_source_link(feed) do
    "/source/#{URI.encode(feed["feed"], &(&1 != ?/ and &1 != ?: and &1 != ??))}:#{feed["type"]}"
  end

end
