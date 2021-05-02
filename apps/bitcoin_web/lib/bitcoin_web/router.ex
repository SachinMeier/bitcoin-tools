defmodule BitcoinWeb.Router do
  use BitcoinWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BitcoinWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/public-key" do
      resources "/", PublicKeyController, only: [:index, :new, :create]
      get "/display", PublicKeyController, :display, singleton: true
    end

    scope "/private-key" do
      resources "/", PrivateKeyController, only: [:index, :create]
      get "/parse", PrivateKeyController, :parse, singleton: true
      get "/display", PrivateKeyController, :display, singleton: true
      get "/sign_message", PrivateKeyController, :sign_message
      get "/convert", PrivateKeyController, :convert
    end

    scope "/signature" do
      resources "/", SignatureController, only: [:index, :new, :create]
      get "/parse", SignatureController, :parse, singleton: true
      get "/display", SignatureController, :display, singleton: true
      get "/verify", SignatureController, :verify, singleton: true
    end


  end

  # Other scopes may use custom stacks.
  # scope "/api", BitcoinWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BitcoinWeb.Telemetry
    end
  end
end
