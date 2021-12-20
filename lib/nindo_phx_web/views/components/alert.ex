defmodule NindoPhxWeb.AlertComponent do
  @moduledoc """
  Component to render pretty Phoenix Flashes.

  All these functions need at least a map with a `:title` key and a `:message` key.
  """

  use Phoenix.Component
  use Phoenix.HTML

  @doc """
  Render an info message.
  """
  def message(%{message: nil} = assigns), do: ~H""
  def message(assigns), do:
    alert(%{color: "indigo", title: assigns.title, message: assigns.message})

  @doc """
  Render an error message.
  """
  def error(%{message: nil} = assigns), do: ~H""
  def error(assigns), do:
    alert(%{color: "red", title: assigns.title, message: assigns.message})

  @doc """
  Render an success message.
  """
  def success(%{message: nil} = assigns), do: ~H""
  def success(assigns), do:
    alert(%{color: "green", title: assigns.title, message: assigns.message})

  @doc """
  Render a custom message.

  This method also needs a tailwind base color in the map.
  """
  def alert(assigns) do
    ~H"""
      <div class="absolute text-center w-full lg:px-4">
        <div class={"p-2 bg-#{@color}-800 items-center text-#{@color}-100 leading-none lg:rounded-full flex lg:inline-flex"} role="alert">
          <span class={"flex rounded-full bg-#{@color}-500 uppercase px-2 py-1 text-xs font-bold mr-3"}><%= @title %></span>
          <span class="font-semibold mr-2 text-left flex-auto"><%= @message %></span>
        </div>
      </div>
    """
  end
  # bg-red-800 bg-indigo-800 bg-green-800 text-red-100 text-green-100 text-indigo-100
  # bg-green-500 bg-green-500 bg-red-500
end
