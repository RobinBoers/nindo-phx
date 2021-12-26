defmodule NindoPhxWeb.Error.NotFound do
  @moduledoc """
  404 error for LiveViews

  This error can be raised to display the 404 page in a LiveView.

  ## Examples

      if Accounts.exists?(username) do
        {:ok, assign(socket, page_title: username}
      else
        raise NindoPhxWeb.Error.NotFound
      end
  """
  defexception message: "Not found", plug_status: 404
end
