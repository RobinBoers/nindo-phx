defmodule NindoPhxWeb.PageView do
  @moduledoc false
  use NindoPhxWeb, :view
  alias NindoPhxWeb.{Endpoint, SocialView}

  alias Nindo.{Posts}

  alias NindoPhxWeb.{PostComponent, FeedComponent}

  import Routes
  import Nindo.Core

  defdelegate get_source_data(feed), to: SocialView

end
