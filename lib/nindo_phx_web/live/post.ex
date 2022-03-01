defmodule NindoPhxWeb.Live.Post do
  @moduledoc """
  LiveView to display Nindo posts and external posts.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{SocialView, Error}

  alias Nindo.{Accounts, Comments, Format, Posts}

  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
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
        # newest at top
        |> Enum.reverse()

      {:noreply,
       socket
       |> assign(
         :page_title,
         post.title <> " · " <> Format.display_name(account) <> " (@" <> account.username <> ")"
       )
       |> assign(:comments, comments)
       |> assign(:post, post)
       |> assign(:rss, false)}
    else
      raise Error.NotFound
    end
  end

  def handle_params(%{"post" => post_id, "source" => source_id}, _uri, socket) do
    case Cachex.get(:rss, "#{source_id}:#{post_id}") do
      {:ok, nil} ->
        raise Error.NotFound

      {:ok, post} ->
        {:noreply,
         socket
         |> assign(:page_title, post.title <> " · " <> post.author)
         |> assign(:post, post)
         |> assign(:rss, true)}
    end
  end

  @impl true
  def handle_info(:refresh, socket) do
    post = Posts.get(socket.assigns.post.id)

    comments =
      :post
      |> Comments.get(socket.assigns.post.id)
      # newest at top
      |> Enum.reverse()

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
  def render(assigns), do: render(SocialView, "post.html", assigns)

  defp get_font(nil), do: "font-sans"
  defp get_font(font), do: font
end
