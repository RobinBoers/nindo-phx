defmodule NindoPhxWeb.Live.Components.NewPost do
  @moduledoc """
  Live for the new post form.
  """
  use NindoPhxWeb, :live_component

  alias Nindo.{Posts, Feeds}

  import Nindo.Core

  @impl true
  def render(assigns) do
    ~H"""
    <section class="new-post-section print:hidden">
      <button class={"new-post-btn btn-primary mb-6 " <> if @visible, do: "hidden", else: "block"} phx-click="toggle-visible" phx-target={@myself}>New post</button>
      <div class={"new-post-modal transition-height overflow-y-hidden w-full " <> if @visible, do: "h-64", else: "h-0"}>
          <div class="mb-6 p-1">
            <.form let={f} for={@changeset} class="new-post-form w-full" phx-submit="publish" phx-target={@myself}>
              <%= text_input f, :title, placeholder: "Title", class: "new-post-form-title w-full mb-2 input block resize-none flex-grow" %>
              <%= textarea f, :body, autofocus: "autofocus", placeholder: "Write something inspirational... ", class: "new-post-form-body w-full input block flex-grow md-mark" %>
              <button class="new-post-submit btn-primary mt-2" type="submit">Publish</button>
              <button class="new-post-cancel btn-secondary mt-2" type="button" phx-click="toggle-visible" phx-target={@myself}>Cancel</button>
            </.form>
          </div>
      </div>

      <script>
        //function newPost() {
        //  document.querySelector(".new-post-modal").style.height = '250px';
			  //  document.querySelector(".new-post-btn").style.display = 'none';
        //}
        //function cancelPost() {
        //  document.querySelector(".new-post-modal").style.height = '0px';
		    //	document.querySelector(".new-post-btn").style.display = 'block';
        //}
      </script>
    </section>
    """
  end

  @impl true
  def mount(socket) do
    changeset = Posts.validate(nil, nil, nil, %{id: 0})
    {:ok, assign(socket, changeset: changeset, visible: false)}
  end

  @impl true
  def handle_event("toggle-visible", _, socket) do
    {:noreply, assign(socket, visible: !socket.assigns.visible)}
  end

  def handle_event("publish", %{"post" => %{"body" => body, "title" => title}}, socket) do
    case Posts.new(title, body, nil, socket.assigns.user) do
      {:ok, _post}    ->
        Task.async(fn -> Feeds.update_cache(socket.assigns.user) end)
        send(self(), :refresh)

        changeset = Posts.validate(nil, nil, nil, %{id: 0})
        {:noreply, socket
        |> assign(:changeset, changeset)}
      {:error, error} ->
        {:noreply, socket
        |> assign(:error, format_error(error))}
    end
  end
end
