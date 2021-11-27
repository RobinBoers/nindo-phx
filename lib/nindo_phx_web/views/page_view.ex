defmodule NindoPhxWeb.PageView do
  @moduledoc false

  use NindoPhxWeb, :view

  alias Nindo.{Posts, Format}
  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.{PostComponent, FeedComponent, ProfileComponent, SocialView}

  import Nindo.Core

end
