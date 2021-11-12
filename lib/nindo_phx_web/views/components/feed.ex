defmodule NindoPhxWeb.FeedComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{RSS}
  alias NindoPhxWeb.SocialView
  alias NindoPhxWeb.PostComponent

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
      assigns.sources
      |> Enum.map(fn source -> Task.async(fn ->
        source
        |> RSS.parse_feed()
        |> RSS.generate_posts()
      end) end)
      |> Task.await_many()
      |> List.flatten()
      |> Enum.sort_by(&(&1.datetime), {:desc, NaiveDateTime})

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

end
