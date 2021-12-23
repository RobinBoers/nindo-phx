defmodule NindoPhxWeb.Live.Post do
  @moduledoc """
  LiveView to display Nindo posts and external posts.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{SocialView}

  alias Nindo.{Accounts, Feeds, Comments, Format, Posts}

  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket
    |> assign(:font, "font-sans")
    |> assign(:logged_in?, logged_in?(session))
    |> assign(:user, user(session))}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    post = Nindo.Posts.get(id)
    if post != nil do
      account = Accounts.get(post.author_id)
      comments =
        :post
        |> Comments.get(id)
        |> Enum.reverse # newest at top

      {:noreply, socket
      |> assign(:page_title, post.title <> " · " <> Format.display_name(account.username) <> " (@" <> account.username <> ")")
      |> assign(:comments, comments)
      |> assign(:post, post)
      |> assign(:rss, false)}
    else
      {:noreply, socket
      |> assign(:page_title, "Wow, such empty")
      |> assign(:comments, [])
      |> assign(:post, post)
      |> assign(:rss, false)}
    end
  end

  def handle_params(%{"datetime" => datetime, "title" => title, "url" => url}, _uri, socket) do
    datetime = from_string(datetime)
    post = Feeds.get_post(url, title, datetime)

    {:noreply, socket
    |> assign(:page_title, post.title <> " · " <> post.author)
    |> assign(:post, post)
    |> assign(:rss, true)}
  end

  @impl true
  def handle_info(:refresh, socket) do
    post = Posts.get(socket.assigns.post.id)
    comments =
      :post
      |> Comments.get(socket.assigns.post.id)
      |> Enum.reverse # newest at top
    {:noreply, assign(socket, post: post, comments: comments)}
  end

  @impl true
  def handle_event("put-flash", %{"message" => message}, socket) do
    {:noreply, put_flash(socket, :success, message)}
  end

  def handle_event("set-font", %{"font" => font}, socket) do
    {:noreply, assign(socket, font: get_font(font))}
  end

  @impl true
  def render(assigns), do: render SocialView, "post.html", assigns

  defp get_font(nil), do: "font-sans"
  defp get_font("sans"), do: "font-sans"
  defp get_font("display"), do: "font-display"
  defp get_font("serif"), do: "font-serif"
  defp get_font(font), do: "font-[#{font}]"
end
