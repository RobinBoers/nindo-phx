defmodule NindoPhxWeb.Live.Components.NewPost do
  @moduledoc false
  use NindoPhxWeb, :live_component

  alias Nindo.{Posts, Feeds}
  import Nindo.Core

  @impl true
  def render(assigns) do
    ~H"""
    <section class="new-post-section">
      <button class="new-post-btn btn-primary mb-6" onclick="newPost()" phx-update="ignore">New post</button>
      <div class="new-post-modal transition-height h-0 overflow-y-hidden w-full" phx-update="ignore">
          <div class="mb-6 p-1">
            <.form let={f} for={@changeset} class="new-post-form w-full" phx-change="validate" phx-submit="publish" phx-target={@myself}>
              <%= text_input f, :title, placeholder: "Title", class: "new-post-form-title w-full mb-2 input block resize-none flex-grow" %>
              <%= textarea f, :body, autofocus: "autofocus", placeholder: "Write something inspirational... ", class: "new-post-form-body w-full input block resize-none flex-grow" %>
              <button class="new-post-submit btn-primary mt-2" type="submit">Publish</button>
              <button class="new-post-cancel btn-secondary mt-2" type="button"  onclick="cancelPost()">Cancel</button>
            </.form>
          </div>
      </div>

      <script>
        function newPost() {
          document.querySelector(".new-post-modal").style.height = '250px';
			    document.querySelector(".new-post-btn").style.display = 'none';
        }
        function cancelPost() {
          document.querySelector(".new-post-modal").style.height = '0px';
		    	document.querySelector(".new-post-btn").style.display = 'block';
        }
      </script>
    </section>
    """
  end

  @impl true
  def mount(socket) do
    changeset = Posts.validate(nil, nil, nil, %{id: 0})
    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => %{"body" => body, "title" => title}}, socket)
  when socket.assigns.user != nil do
    changeset = Posts.validate(title, body, nil, socket.assigns.user)

    {:noreply, socket
    |> assign(:changeset, changeset)
    |> assign(:error, format_error(changeset))}
  end

  @impl true
  def handle_event("publish", %{"post" => post}, socket)
  when socket.assigns.user != nil do
    user = socket.assigns.user
    IO.inspect("Publishing new post.")

    case Posts.new(post["title"] , post["body"], nil, user) do
      {:ok, _post}    ->
        Task.async(fn -> Feeds.update_cache(user) end)
        send(self(), :refresh)
        {:noreply, socket}
      {:error, error} ->
        {:noreply, socket
        |> assign(:error, format_error(error))}
    end
  end
end
