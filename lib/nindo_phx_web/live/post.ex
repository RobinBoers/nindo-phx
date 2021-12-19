defmodule NindoPhxWeb.Live.Post do
  @moduledoc """
  LiveView to display Nindo posts and external posts.
  """
  use NindoPhxWeb, :live_view

  alias NindoPhxWeb.{SocialView}

  alias Nindo.{Feeds}
  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign(:logged_in, logged_in?(session))
    |> assign(:user, user(session))}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    post = Nindo.Posts.get(id)

    {:noreply, socket
    |> assign(:post, post)
    |> assign(:rss, false)}
  end

  def handle_params(%{"datetime" => datetime, "title" => title, "url" => url}, _uri, socket) do
    datetime = from_string(datetime)
    post = Feeds.get_post(url, title, datetime)

    {:noreply, socket
    |> assign(:post, post)
    |> assign(:rss, true)}
  end

  @impl true
  def render(assigns), do: render SocialView, "post.html", assigns
end
