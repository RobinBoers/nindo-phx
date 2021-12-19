defmodule NindoPhxWeb.PageView do
  @moduledoc false

  use NindoPhxWeb, :view

  alias Nindo.{Posts}
  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.{PostComponent, FeedComponent, SocialView}

  alias NindoPhxWeb.Endpoint

  import Nindo.Core

  defdelegate get_source_data(feed), to: SocialView

end
