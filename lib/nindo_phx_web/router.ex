defmodule NindoPhxWeb.Router do
  @moduledoc false
  use NindoPhxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NindoPhxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug NindoPhxWeb.API.Auth
  end

  scope "/", NindoPhxWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/blog", PageController, :blog

    get "/app", SocialController, :app
    get "/welcome", SocialController, :welcome
    live "/home", Live.Social
    live "/social", Live.Social
    live "/discover", Live.Discover
    live "/sources", Live.Sources

    get "/search", SocialController, :search
    get "/search/:query", SocialController, :search

    get "/post/external", SocialController, :external_post
    get "/post/:id", SocialController, :post
    get "/user/:username", SocialController, :user
    get "/follow/:username", SocialController, :follow
    get "/feed/:username", SocialController, :feed
    get "/source/:source", SocialController, :external_feed

    put "/post/new", SocialController, :new_post
    put "/comment/new", SocialController, :new_comment

    get "/account", AccountController, :index
    get "/settings", AccountController, :index
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
    scope "/api", NindoPhxWeb do
      pipe_through :api

      get "/accounts", APIController, :list_accounts
      put "/accounts", APIController, :create_account
      get "/accounts/:username", APIController, :get_account
      put "/accounts/:username", APIController, :change_account

      get "/posts", APIController, :list_posts
      put "/posts", APIController, :new_post
      get "/posts/:id", APIController, :get_post

      post "/login", AccountController, :login
    end
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
