defmodule NindoPhxWeb.PostComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{Format}
  alias NindoPhxWeb.Endpoint
  import NindoPhxWeb.Router.Helpers

  import Nindo.Core

  #       <h3 class="text-2xl mt-3 px-4"><%= @post.title %></h3>
  def default(assigns) do
    ~H"""
    <%= if @post != nil do %>
    <div id={@post.title} class="w-full my-6 rounded-md shadow bg-white dark:bg-gray-800 overflow-x-hidden">
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

        <%= if @post.source["type"] == "youtube" and not debug_mode?() do %>
          <% [_, video_id] = String.split(@post.link, "=") %>

          <iframe class="rounded-md aspect-video w-full" src={"https://www.youtube.com/embed/#{video_id}"} title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen/>
        <% end %>

        <div class="px-4 py-2 text-lg post-content"><%=  safe @post.body %></div>
      <% else %>
        <div class="px-4 pt-2 text-lg post-content"><%= safe markdown @post.body %></div>
      <% end %>

      <p class="px-4 pb-2 italic text-gray-500">Posted on <%= human_datetime(@post.datetime) %></p>
    </div>
    <% end %>
    """
  end

  def preview(assigns) do
    ~H"""
      <div class="mb-6">
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

          <h3 class="text-xl sm:text-2xl font-medium px-4"><%= link @post.title, to: social_path(Endpoint, :external_post, url: @post.source["feed"], title: @post.title, datetime: NaiveDateTime.to_string @post.datetime) %></h3>

        <% else %>

          <h3 class="text-xl sm:text-2xl font-medium px-4"><a href={"/post/#{@post.id}"}><%= @post.title %></a></h3>

        <% end %>
      </div>
    """
  end

  def new(assigns) do
    ~H"""
      <button class="btn-primary mb-6 new-post-btn" onclick="newPost()">New post</button>
      <div class="new-post-modal transition-height h-0 overflow-y-hidden w-full">
          <div class="mb-6 p-1">
            <%= form_for(@conn, social_path(Endpoint, :new_post), [as: :post, method: :put, class: "new-post-form w-full", id: "post-form"], fn f -> %>
              <%= text_input f, :title, placeholder: "Title", class: "w-full mb-2 input block resize-none flex-grow" %>
              <%= textarea f, :body, autofocus: "autofocus", placeholder: "Write something inspirational... ", class: "w-full input block resize-none flex-grow" %>
            <% end) %>
            <button class="btn-primary mt-2" onclick="submit()">Publish</button>
            <button class="btn-secondary mt-2" onclick="cancel()">Cancel</button>
          </div>
      </div>

      <script>
        function newPost() {
          document.querySelector(".new-post-modal").style.height = '250px';
          document.querySelector(".new-post-btn").style.display = 'none';
        }
        function cancel() {
          document.querySelector(".new-post-modal").style.height = '0px';
          document.querySelector(".new-post-btn").style.display = 'block';
        }
        function submit() {
          document.querySelector(".new-post-form").submit();
        }
      </script>
    """
  end

  # Private methods

  defp get_source_link(feed) do
    "/source/#{URI.encode(feed["feed"], &(&1 != ?/ and &1 != ?: and &1 != ??))}:#{feed["type"]}"
  end

end
