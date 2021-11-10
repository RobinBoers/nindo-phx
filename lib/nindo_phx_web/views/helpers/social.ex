defmodule NindoPhxWeb.SocialHelpers do
  @moduledoc false

  import NindoPhxWeb.ViewHelpers

  # Profile page

  def default_profile_picture() do
    "https://www.multisignaal.nl/wp-content/uploads/2021/08/blank-profile-picture-973460_1280.png"
  end

  def description(username) do
    case description = Nindo.Accounts.get_by(:username, username).description do
      nil ->    safe "<i>No account description available.</i>"
      _   ->    description
    end
  end
  def display_name(username) do
    case display_name = Nindo.Accounts.get_by(:username, username).display_name do
      nil ->    String.capitalize username
      _   ->    display_name
    end
  end
  def profile_picture(username) do
    case profile_picture = Nindo.Accounts.get_by(:username, username).profile_picture do
      nil ->    default_profile_picture()
      _   ->    profile_picture
    end
  end

  # Post feed

  def get_posts(username) do
    account = Nindo.Accounts.get_by(:username, username)
    Nindo.Posts.get(:user, account.id)
    |> Enum.reverse() # reverse because otherwise the newest post will be at the bottom in EEx
  end

  # Discover page

  def get_users() do
    Nindo.Accounts.list(6)
    |> Enum.sort_by(&(&1.username))
    #|> Enum.shuffle() # shuffle to make a random order
  end

end
