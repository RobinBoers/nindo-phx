defmodule NindoPhxWeb.AlertComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  def message(assigns), do:
    alert(%{color: "indigo", title: assigns.title, message: assigns.message})

  def error(assigns), do:
    alert(%{color: "red", title: assigns.title, message: assigns.message})

  def success(assigns), do:
    alert(%{color: "green", title: assigns.title, message: assigns.message})

  def alert(assigns) do
    ~H"""
      <div class="text-center py-4 lg:px-4">
        <div class={"p-2 bg-#{@color}-800 items-center text-#{@color}-100 leading-none lg:rounded-full flex lg:inline-flex"} role="alert">
          <span class={"flex rounded-full bg-#{@color}-500 uppercase px-2 py-1 text-xs font-bold mr-3"}><%= @title %></span>
          <span class="font-semibold mr-2 text-left flex-auto"><%= @message %></span>
        </div>
      </div>
    """
  end
end
