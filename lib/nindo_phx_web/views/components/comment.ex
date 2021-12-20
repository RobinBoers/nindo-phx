defmodule NindoPhxWeb.CommentComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.{Endpoint, Live}

  alias Nindo.{Format}

  import Nindo.Core

  def show(assigns) do
    ~H"""
      <div id={@comment.title} class="w-full mb-6 rounded-md shadow bg-white dark:bg-gray-800">
        <div class="pt-4 p-3 flex flex-row justify-between items-bottom">
          <div class="flex flex-row items-center justify-start">
              <% username = Nindo.Accounts.get(@comment.author_id).username %>
              <img class="w-6 object-cover h-6 rounded-full border border-indigo-700 border-2" src={Format.profile_picture(username)}>
              <p class="font-bold text-lg pl-2">
                <%= live_patch Format.display_name(username), to: live_path(Endpoint, Live.User, username) %>
              </p>
            </div>
        </div>
        <hr class="clear-both">

        <div class="p-5 text-lg post-content font-roboto"><%= safe markdown @comment.body %></div>
    </div>
    """
  end
end
