defmodule NindoPhxWeb.PageView do
  @moduledoc false

  use NindoPhxWeb, :view

  alias Nindo.{Posts}
  import NindoPhxWeb.Router.Helpers
  alias NindoPhxWeb.{PostComponent, FeedComponent}

  alias NindoPhxWeb.Endpoint

  import Nindo.Core

end
