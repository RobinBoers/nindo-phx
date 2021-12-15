defmodule NindoPhxWeb.Live.NewPostComponent do
  @moduledoc false
  use NindoPhxWeb, :live_component

  alias Nindo.Posts
  alias NindoPhxWeb.AccountController

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <button class="btn-primary mb-6 new-post-btn" onclick="newPost()">New post</button>
      <div class="new-post-modal transition-height h-0 overflow-y-hidden w-full">
          <div class="mb-6 p-1">
            <%# f = form as: "post" class: "new-post-form w-full" "phx-submit"="new-post" %>
              <%# text_input f, :title, placeholder: "Title", class: "w-full mb-2 input block resize-none flex-grow" %>
              <%# textarea f, :body, autofocus: "autofocus", placeholder: "Write something inspirational... ", class: "w-full input block resize-none flex-grow" %>
            <%# form %>
            <button class="btn-primary mt-2" onclick="submit()">Publish</button>
            <button class="btn-secondary mt-2" onclick="cancel()">Cancel</button>
          </div>
      </div>

      <script>
        function newPost() {
          document.querySelector(".new-post-modal").style.height = '250px';
          document.querySelector(".new-post-btn").style.display = 'none';
        }
        function cancel() {
          document.querySelector(".new-post-modal").style.height = '0px';
          document.querySelector(".new-post-btn").style.display = 'block';
        }
        function submit() {
          document.querySelector(".new-post-form").submit();
        }
      </script>
    """
  end

  def handle_event("new-post", %{"post" => post}, socket) do
    title = post["title"]
    body = post["body"]
    #user = user(conn)

    # case Posts.new(title, body, nil, user) do
    #   {:ok, _post}    ->
    #     Feeds.update_cache(user)
    #     {:ok, socket}
    #   {:error, error} ->
    #     {:noreply, socket
    #     |> assign(:error, AccountController.format_error(error))}
    # end
  end
end
