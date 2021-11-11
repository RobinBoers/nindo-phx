defmodule NindoPhxWeb.LayoutView do
  @moduledoc false

  use NindoPhxWeb, :view

  import NindoPhxWeb.{Router.Helpers}
  alias NindoPhxWeb.{BarComponent}
  alias Nindo.{Accounts, Posts, Format}
  alias Phoenix.Controller

  import Nindo.Core

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def title(:index, _),       do: "Social media of the Future"
  def title(:blog, _),        do: "Blog"
  def title(:discover, _),    do: "Discover"
  def title(:about, _),       do: "About"
  def title(:sign_up, _),     do: "Sign up"
  def title(:sign_in, _),     do: "Sign in"
  def title(:user, assigns),  do: Format.display_name(assigns.username) <> " (@" <> assigns.username <> ")"

  def title(:post, assigns) do
    post = Posts.get(assigns.id)
    account = Accounts.get(post.author_id)

    post.title <> " · " <> Format.display_name(account.username) <> " (@" <> account.username <> ")"
  end

  def title(_, _),            do: "Social media of the Future"

end
