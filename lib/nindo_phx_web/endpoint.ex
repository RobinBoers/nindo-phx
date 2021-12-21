defmodule NindoPhxWeb.Endpoint do
  @moduledoc false
  use Phoenix.Endpoint, otp_app: :nindo_phx

  @session_options [
    store: :cookie,
    key: "_nindo_phx_key",
    signing_salt: "2Lwgg2GS"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :nindo_phx,
    gzip: false,
    only: ~w(assets fonts docs images manifest.webmanifest favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug NindoPhxWeb.Router
end
