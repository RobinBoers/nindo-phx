defmodule NindoPhxWeb.FeedComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias NindoPhxWeb.SocialView
  alias NindoPhxWeb.PostComponent

  def single(assigns), do:
    feed %{posts: SocialView.get_posts(assigns.username), user_link: assigns.user_link, rss: false}

  def mixed(assigns) do
    feed =
      assigns.users
      |> Enum.map(fn user -> SocialView.get_posts(user) end)
      |> List.flatten()
      |> Enum.sort_by(&(&1.datetime), {:desc, NaiveDateTime})

    feed %{posts: feed, user_link: assigns.user_link, rss: false}
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

end
