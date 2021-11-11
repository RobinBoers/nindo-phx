defmodule NindoPhxWeb.BarComponent do
  @moduledoc false

  use Phoenix.Component
  use Phoenix.HTML

  import NindoPhxWeb.Router.Helpers
  alias Nindo.{Accounts, Format}

  def account_header(assigns) do
    account = Accounts.get(assigns.id)

    ~H"""
      <p class="header-item">
        <a href="/account"><i class="fas fa-user-circle mr-1"></i> <%=
          Format.display_name(account.username)
        %></a>
      </p>

      <%= link "Logout", to: account_path(@conn, :logout), class: "header-item header-button btn-secondary hidden lg:block" %>
    """
  end
end
