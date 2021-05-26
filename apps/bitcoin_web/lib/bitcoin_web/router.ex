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

    scope "/stats" do
      get "/", StatsController, :index
    end

    scope "/public-key" do
      resources "/", PublicKeyController, only: [:index, :new]
      get "/display", PublicKeyController, :display
      post "/display", PublicKeyController, :display
    end

    scope "/private-key" do
      resources "/", PrivateKeyController, only: [:index]
      get "/parse", PrivateKeyController, :parse
      get "/display", PrivateKeyController, :display
      post "/display", PrivateKeyController, :display
      get "/sign_message", PrivateKeyController, :sign_message
      get "/convert", PrivateKeyController, :convert
    end

    scope "/signature" do
      resources "/", SignatureController, only: [:index, :new]
      get "/parse", SignatureController, :parse
      get "/display", SignatureController, :display
      post "/display", SignatureController, :display
      get "/verify", SignatureController, :verify
    end

    # scope "/transaction" do
    #   resources "/", TransactionController, only: [:index]
    #   get "/display", TransactionController, :display
    #   post "/display", TransactionController, :display
    #   get "/parse", TransactionController, :parse
    #   get "/verify", TransactionController, :verify
    # end

    scope "/encoder" do
      get "/", EncoderController, :index
      get "/sha256", EncoderController, :sha256
      post "/sha256", EncoderController, :sha256
      get "/ripemd160", EncoderController, :ripemd160
      post "/ripemd160", EncoderController, :ripemd160
      get "/hash160", EncoderController, :hash160
      post "/hash160", EncoderController, :hash160
      get "/hex", EncoderController, :hex
      post "/hex", EncoderController, :hex
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
