defmodule NindoPhxWeb.LayoutView do
  @moduledoc false

  use NindoPhxWeb, :view
  alias Phoenix.Controller
  alias NindoPhxWeb.{PageController, AccountController, SocialController}

  alias Nindo.{Accounts, Format}
  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.{BarComponent}

  import Nindo.Core

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def title(:index, PageController, _),       do: "Social media of the Future"
  def title(:index, AccountController, _),    do: "Settings"
  def title(:index, SocialController, _),     do: "Social"
  def title(:blog, _, _),                     do: "Blog"
  def title(:discover, _, _),                 do: "Discover"
  def title(:sources, _, _),                 do: "Sources"
  def title(:about, _, _),                    do: "About"
  def title(:sign_up, _, _),                  do: "Sign up"
  def title(:sign_in, _, _),                  do: "Sign in"
  def title(:user, _, assigns) do
    if Accounts.exists?(assigns.username) do
      Format.display_name(assigns.username) <> " (@" <> assigns.username <> ")"
    else
      "Unknown user" <> " (@deleted)"
    end
  end

  def title(:post, _, assigns) do
    case assigns.post != nil do
      true ->
        account = Accounts.get(assigns.post.author_id)

        assigns.post.title <> " · " <> Format.display_name(account.username) <> " (@" <> account.username <> ")"
      false ->
        "Wow, such empty"
    end
  end

  def title(:external, _, assigns), do: assigns.title
  def title(_, _, _),            do: "Nindo"

end
