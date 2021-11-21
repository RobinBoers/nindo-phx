defmodule NindoPhxWeb.PostComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{Format}
  import NindoPhxWeb.Router.Helpers

  import Nindo.Core

  #       <h3 class="text-2xl mt-3 px-4"><%= @post.title %></h3>
  def default(assigns) do
    ~H"""
    <div id={@post.title} class="w-full my-6 rounded shadow bg-white text-black">
      <div class="pt-4 p-3 flex flex-row justify-between items-bottom">
        <div class="flex flex-row items-center justify-start">
            <%= if @rss do %>

              <img class="w-12" src={@post.source["icon"]} onerror="this.src='/images/rss.png'">

              <p class="font-bold text-lg pl-2">
                <%= if @user_link do %>
                  <a href={get_source_link(@post.source)}><%= @post.author %></a>
                <% else %>
                  <%= @post.author %>
                <% end %>

                <i class="block text-sm text-gray-400">@external</i>
              </p>

            <% else %>

              <% username = Nindo.Accounts.get(@post.author_id).username %>

              <img class="w-12 object-cover h-12 rounded-full border border-indigo-700 border-2" src={Format.profile_picture(username)}>
              <p class="font-bold text-lg pl-2">
                <%= if @user_link do %>
                  <a href={"/user/#{username}"}><%= Format.display_name(username) %></a>
                <% else %>
                  <%= Format.display_name(username) %>
                <% end %>
                <i class="block text-sm text-gray-400"><%= "@#{username}" %></i>
              </p>

            <% end %>
          </div>

      </div>
      <hr class="clear-both">


      <%= if @rss do %>

        <%= if @post.type == "youtube" and not debug_mode() do %>
          <% [_, video_id] = String.split(@post.link, "=") %>

          <iframe class="w-full h-96" src={"https://www.youtube.com/embed/#{video_id}"} title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen/>
        <% end %>

        <div class="p-4 text-sm post-content"><%=  safe @post.body %></div>
      <% else %>
        <div class="p-4 text-lg post-content" style="font-family: Roboto;"><%= @post.body %></div>
      <% end %>

      <p class="px-4 pb-2 italic text-gray-500">Posted on <%= human_datetime(@post.datetime) %></p>
    </div>
    """
  end

  def standalone(assigns) do
    username = Nindo.Accounts.get(assigns.post.author_id).username
    ~H"""
      <div class="flex flex-row items-center gap-2 pt-7">
        <img class="w-6 object-cover h-6 rounded-full border border-indigo-700 border-2" src={Format.profile_picture(username)}>
        <p class="font-bold text-lg">
            <a href={"/user/#{username}"}><%= Format.display_name(username) %></a>
        </p>
      </div>

      <h2 class="title no-top"><%= @post.title %></h2>
      <p class="text-lg"><%= @post.body %></p>
    """
  end

  def preview(assigns) do
    ~H"""
      <div class="my-6">
        <div class="flex flex-row items-center gap-2">
          <%= if @rss do %>

            <img class="w-6" src={@post.source["icon"]} onerror="this.src='/images/rss.png'">

            <p class="font-bold text-lg">
              <%= if @user_link do %>
                <a href={get_source_link(@post.source)}><%= @post.author %></a>
              <% else %>
                <%= @post.author %>
              <% end %>
            </p>

          <% else %>

            <% username = Nindo.Accounts.get(@post.author_id).username %>

            <img class="w-6 object-cover h-6 rounded-full border border-indigo-700 border-2" src={Format.profile_picture(username)}>
            <p class="font-bold text-lg">
              <%= if @user_link do %>
                <a href={"/user/#{username}"}><%= Format.display_name(username) %></a>
              <% else %>
                <%= Format.display_name(username) %>
              <% end %>
            </p>

          <% end %>
        </div>

        <%= if @rss do %>

          <h3 class="text-xl sm:text-2xl font-medium px-4"><a href={get_source_link(@post.source) <> "##{@post.title}"}><%= @post.title %></a></h3>

        <% else %>

          <h3 class="text-xl sm:text-2xl font-medium px-4"><a href={"/post/#{@post.id}"}><%= @post.title %></a></h3>

        <% end %>
      </div>
    """
  end

  def new(assigns) do
    ~H"""
      <div class="w-full flex-grow-0 rounded text-black">
          <div class="pt-4">
            <%= form_for(@conn, social_path(@conn, :new_post), [as: :post, method: :put, class: "w-full", id: "post-form"], fn f -> %>
              <%= text_input f, :title, placeholder: "Title", class: "w-full mb-2 input block border-none resize-none shadow flex-grow text-black" %>
              <%= textarea f, :body, autofocus: "autofocus", placeholder: "Write something inspirational... ", onkeydown: "pressed(event)", class: "w-full input block border-none resize-none shadow flex-grow text-black" %>
            <% end) %>
          </div>
      </div>

      <script>
        function pressed(e) {
          if ( (window.event ? event.keyCode : e.which) == 13) {
              document.getElementById("post-form").submit();
          }
        }
      </script>
    """
  end

  # Private methods

  defp get_source_link(feed) do
    "/source/#{URI.encode(feed["feed"], &(&1 != ?/ and &1 != ?: and &1 != ??))}:#{feed["type"]}"
  end

end
