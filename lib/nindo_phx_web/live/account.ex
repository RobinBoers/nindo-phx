defmodule NindoPhxWeb.Live.Account do
  @moduledoc """
  LiveView to manage account preferences.
  """
  use NindoPhxWeb, :live_view
  alias NindoPhxWeb.{Endpoint, AccountView}

  alias Nindo.{Accounts, Auth}

  import Routes
  import Nindo.Core

  @impl true
  def mount(_params, session, socket) do
    case logged_in?(session) do
      true  -> {:ok, socket
      |> assign(:page_title, "Settings")
      |> assign(:user, user(session))
      |> assign(:edit_avatar, false)
      |> assign(:logged_in?, true)}

      _     -> {:ok, redirect(socket, to: account_path(Endpoint, :sign_in))}
    end
  end

  @impl true
  def render(assigns), do: render AccountView, "index.html", assigns

  @impl true
  def handle_event("edit-avatar", _, socket) do
    {:noreply, assign(socket, :edit_avatar, !socket.assigns.edit_avatar)}
  end

  def handle_event("update-avatar", %{"avatar" => %{"url" => url}}, socket) do
    Accounts.change(:profile_picture, url, socket.assigns.user)
    user = Accounts.get(socket.assigns.user.id)

    {:noreply, socket
    |> assign(:user, user)}
  end

  def handle_event("update-prefs", %{"prefs" => %{"description" => description, "display_name" => display_name, "email" => email}}, socket) do
    Accounts.change(:display_name, display_name, socket.assigns.user)
    Accounts.change(:email, email, socket.assigns.user)
    Accounts.change(:description, description, socket.assigns.user)

    user = Accounts.get(socket.assigns.user.id)

    {:noreply, socket
    |> assign(:user, user)}
  end

  def handle_event("update-password", %{"password" => %{"check" => check, "password" => password}}, socket) do
    if check == password do
      salt = socket.assigns.user.salt
      password = Auth.hash_pass(password, salt)

      Accounts.change(:password, password, socket.assigns.user)
      {:noreply, socket
      |> put_flash(:success, "Password updated")}
    else
      {:noreply, socket
      |> put_flash(:error, "Passwords don't match")}
    end
  end
end
