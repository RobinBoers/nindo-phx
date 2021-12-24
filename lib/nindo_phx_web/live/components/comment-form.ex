defmodule NindoPhxWeb.Live.Components.CommentForm do
  @moduledoc """
  LiveView for the comment form.
  """
  use NindoPhxWeb, :live_component

  alias Nindo.{Comments}

  @impl true
  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={:comment} class="comment-form w-full" phx-submit="publish" phx-target={@myself}>
          <%= text_input f, :title, placeholder: "Title", class: "w-full mb-2 input block resize-none flex-grow" %>
          <%= hidden_input f, :post_id, value: @post_id %>
          <%= textarea f, :body, placeholder: "What do you think? ", onkeydown: "pressed(event)", class: "w-full input block resize-none flex-grow" %>
          <%= submit "Post reply", class: "btn-primary mt-2" %>
        </.form>
      </div>
    """
  end

  @impl true
  def handle_event("publish", %{"comment" => %{"body" => body, "post_id" => id, "title" => title}}, socket) do
    case Comments.new(id, title, body, socket.assigns.user) do
      {:ok, _comment} ->
        send(self(), :refresh)
        {:noreply, socket}
      {:error, error} ->
        {:noreply, put_flash(socket, :error, error)}
    end
  end
end
