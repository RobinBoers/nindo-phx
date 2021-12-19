defmodule NindoPhxWeb.CommentComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{Format, Comments}

  import Nindo.Core

  def show(assigns) do
    ~H"""
      <div id={@comment.title} class="w-full mb-6 rounded-md shadow bg-white dark:bg-gray-800">
        <div class="pt-4 p-3 flex flex-row justify-between items-bottom">
          <div class="flex flex-row items-center justify-start">
              <% username = Nindo.Accounts.get(@comment.author_id).username %>
              <img class="w-6 object-cover h-6 rounded-full border border-indigo-700 border-2" src={Format.profile_picture(username)}>
              <p class="font-bold text-lg pl-2">
                <a href={"/user/#{username}"}><%= Format.display_name(username) %></a>
              </p>
            </div>
        </div>
        <hr class="clear-both">

        <div class="p-5 text-lg post-content font-roboto"><%= safe markdown @comment.body %></div>
    </div>
    """
  end

  def section(assigns) do
    comments = Comments.get(:post, assigns.post_id)
    ~H"""
      <%= if comments != [] do %>
        <!--<hr class="mt-24"> -->
        <section class="mt-12">
          <h3 class="tracking-tighter text-5xl font-bold py-9 w-full">Comments</h3>
          <%= for comment <- comments do %>
            <.show comment={comment} />
          <% end %>
        </section>
      <% end %>
    """
  end
end
