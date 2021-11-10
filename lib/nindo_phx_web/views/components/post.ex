defmodule NindoPhxWeb.PostComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  import NindoPhxWeb.ViewHelpers
  alias NindoPhxWeb.SocialHelpers

  def show(assigns) do
    ~H"""
    <div class="w-full my-6 rounded shadow bg-white text-black">
      <div class="flex flex-row items-center justify-start pt-4 p-3">
          <%= if @rss do %>

            <p class="font-bold text-lg pl-2">
              <%= @post.author %>
              <i class="block text-sm text-gray-400">@external</i>
            </p>

          <% else %>

            <% username = Nindo.Accounts.get(@post.author_id).username %>

            <img class="w-12 rounded-full border border border-indigo-700 border-2" src={SocialHelpers.profile_picture(username)}>
            <p class="font-bold text-lg pl-2">
              <%= if @user_link do %>
                <a href={"/user/#{username}"}><%= SocialHelpers.display_name(username) %></a>
              <% else %>
                <%= SocialHelpers.display_name(username) %>
              <% end %>
              <i class="block text-sm text-gray-400"><%= "@#{username}" %></i>
            </p>

          <% end %>
      </div>
      <hr class="clear-both">
      <div class="p-4 text-sm"><%= @post.body %></div>

      <p class="px-4 pb-2 italic text-gray-500">Posted on <%= human_datetime(@post.datetime) %></p>
    </div>
    """
  end
end
