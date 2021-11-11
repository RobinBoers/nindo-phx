defmodule NindoPhxWeb.ProfileComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  alias Nindo.Format

  def header(assigns) do
    ~H"""
    <div class="w-full bg-white rounded-xl shadow-md overflow-hidden">
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
                    <a class="btn-primary">Follow</a>
                    <a class="btn-secondary" href={"/feed/#{@username}"}><i class="fas fa-rss-square text-yellow-600 icon"></i> RSS</a>
                </p>
            </div>
        </div>
    </div>
    """
  end

  def preview(assigns) do
    ~H"""
    <div class="my-6 w-full bg-white rounded-xl shadow-md overflow-hidden">
        <div class="md:flex">
            <div class="md:flex-shrink-0">
                <img class="h-36 w-full object-cover md:h-full md:w-40" src={Format.profile_picture(@username)}>
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
                <p class="mt-2 text-gray-500"><%= Format.description(@username) %></p>
            </div>
        </div>
    </div>
    """
  end

  def edit(assigns) do
    ~H"""
    <div class="my-6 w-full bg-white rounded-xl shadow-md overflow-hidden">
        <div class="md:flex">
            <div class="md:flex-shrink-0">
                <img class="h-36 w-full object-cover md:h-full md:w-40" src={Format.profile_picture(@username)}>
            </div>
            <div class="p-8">
                <p class="font-bold text-2xl">
                    <a href={"/user/#{@username}"}><%= Format.display_name(@username) %></a>
                    <i class="block text-base text-gray-400"><%= "@#{@username}" %></i>
                </p>
                <p class="mt-2 text-gray-500"><%= Format.description(@username) %></p>
            </div>
        </div>
    </div>
    """
  end
end
