defmodule NindoPhxWeb.ProfileComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.{Format}
  import NindoPhxWeb.Router.Helpers

  import Nindo.Core

  def header(assigns) do
    ~H"""
    <div class="w-full bg-white dark:bg-gray-800 mt-12 xl:mt-0 rounded-xl shadow-md overflow-hidden">
        <div class="md:flex">
            <div class="md:flex-shrink-0">
                <img class="h-48 w-full object-cover md:h-full md:w-52" src={Format.profile_picture(@username)}>
            </div>
            <div class="p-8">
                <p class="font-bold text-2xl">
                    <%= Format.display_name(@username) %>
                    <i class="block text-base text-gray-400"><%= "@#{@username}" %></i>
                </p>
                <p class="mt-2 text-gray-500"><%= Format.description(@username) %></p>

                <p class="mt-10">
                    <%= if logged_in?(@conn) do %>
                        <a class="btn-primary mr-1" href={"/follow/#{@username}"}>
                            <%= case @username in user(@conn).following do
                                true -> "Unfollow"
                                false -> "Follow"
                            end %>
                        </a>
                    <% end %>

                    <a class="btn-secondary" href={"/feed/#{@username}"}><i class="fas fa-rss-square text-yellow-600 mr-1"></i> RSS</a>
                </p>
            </div>
        </div>
    </div>
    """
  end

  def preview(assigns) do
    ~H"""
    <%= if not @source do %>

        <div class="my-6 w-full bg-white dark:bg-gray-800 rounded-xl shadow-md overflow-hidden">
            <div class="md:flex">
                <div class="md:flex-shrink-0">
                    <%= if @display_link do %>
                        <a href={"/user/#{@username}"}>
                            <img class="h-36 w-full object-cover md:h-full md:w-40" src={Format.profile_picture(@username)}>
                        </a>
                    <% else %>
                    <img class="h-36 w-full object-cover md:h-full md:w-40" src={Format.profile_picture(@username)}>
                    <% end %>
                </div>
                <div class="p-8">
                    <p class="font-bold text-2xl">
                        <%= if @display_link do %>
                        <a href={"/user/#{@username}"}><%= Format.display_name(@username) %></a>
                        <% else %>
                        <%= Format.display_name(@username) %>
                        <% end %>
                        <i class="block text-base text-gray-400"><%= "@#{@username}" %></i>
                    </p>

                    <%= if logged_in?(@conn) and @show_buttons do %>
                        <p class="mt-6">
                            <a class="btn-primary" href={"/follow/#{@username}"}>
                                <%= case @username in user(@conn).following do
                                    true -> "Unfollow"
                                    false -> "Follow"
                                end %>
                            </a>
                        </p>
                    <% else %>
                    <p class="mt-2 text-gray-500"><%= Format.description(@username) %></p>
                    <% end %>
                </div>
            </div>
        </div>

    <% else %>

        <li class="p-2 py-3 flex flex-row flex-wrap center-items">
            <img class="w-9 object-cover h-9 rounded-full mr-3 border border-indigo-700" src={Format.profile_picture(@username)}>

            <span class="mt-1">
            <%= if @display_link do %>
                <a href={"/user/#{@username}"}><%= Format.display_name(@username) %></a>
            <% else %>
                <%= Format.display_name(@username) %>
            <% end %>
            </span>

            <%= if logged_in?(@conn) and @show_buttons do %>
                <%= link "Unfollow", to: social_path(@conn, :follow, @username), class: "mt-3 no-underline ml-auto hover:bg-gray-200  dark:hover:text-gray-900 w-auto px-2 rounded-full" %>
            <% end %>
        </li>

    <% end %>
    """
  end

  def account(assigns) do
    ~H"""
    <div class="my-6 w-full bg-white dark:bg-gray-800 rounded-xl shadow-md overflow-hidden transition-all">
        <div class="md:flex">
            <div class="md:flex-shrink-0">
                <img class="h-36 w-full object-cover md:h-full md:w-40 hover:opacity-50 hover:cursor-pointer" onclick="toggleEdit()" src={Format.profile_picture(@username)}>
            </div>
            <div class="p-8" id="default">
                <p class="font-bold text-2xl">
                    <a href={"/user/#{@username}"}><%= Format.display_name(@username) %></a>
                    <i class="block text-base text-gray-400"><%= "@#{@username}" %></i>
                </p>
                <p class="mt-2 text-gray-500"><%= Format.description(@username) %></p>
            </div>
            <div class="p-8 hidden flex-grow" id="edit">
                <h3 class="font-bold text-2xl">Profile picture</h3>
                <%= form_for(@conn, account_path(@conn, :update_profile_picture), [as: :prefs, method: :update, class: "flex flex-row flex-wrap"], fn f -> %>
                    <%= text_input f, :url, placeholder: "URL to profile picture", value: user(@conn).profile_picture, class: "input my-1 flex-grow" %>
                    <%= submit "Save", class: "btn-primary ml-4 pt-1 pb-1"  %>
                <% end) %>
            </div>
        </div>
    </div>

    <script>
        function toggleEdit() {
            if(document.getElementById("edit").style.display == "block") {
                document.getElementById("edit").style.display = "none"
                document.getElementById("default").style.display = "block"
            } else {
                document.getElementById("edit").style.display = "block"
                document.getElementById("default").style.display = "none"
            }
        }
    </script>
    """
  end

end
