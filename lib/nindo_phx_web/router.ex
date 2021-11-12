defmodule NindoPhxWeb.Router do
  use NindoPhxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NindoPhxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NindoPhxWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/blog", PageController, :blog

    get "/home", SocialController, :index
    get "/discover", SocialController, :discover
    get "/post/:id", SocialController, :post
    get "/user/:username", SocialController, :user

    get "/sources", RSSController, :sources
    get "/feed/:username", RSSController, :feed
    get "/rss/:source", RSSController, :external

    put "/feed/add", RSSController, :add_feed
    delete "/feed/remove", RSSController, :remove_feed

    get "/account", AccountController, :index
    get "/signin", AccountController, :sign_in
    get "/signup", AccountController, :sign_up

    post "/account/update/prefs", AccountController, :update_prefs
    post "/account/update/profile_picture", AccountController, :update_profile_picture
    post "/account/update/password", AccountController, :change_password

    put "/signup", AccountController, :create_account
    post "/signin", AccountController, :login
    get "/logout", AccountController, :logout
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NindoPhxWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
