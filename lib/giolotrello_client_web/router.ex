defmodule GiolotrelloClientWeb.Router do
  use GiolotrelloClientWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GiolotrelloClientWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug :require_authenticated_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes
  scope "/", GiolotrelloClientWeb do
    pipe_through :browser

    get  "/login", LoginController, :new
    post "/login", LoginController, :create
  end

  # Protected routes
  scope "/", GiolotrelloClientWeb do
    pipe_through [:browser]

    get "/", PageController, :home

    live "/tasks", TaskLive.Index
  end

  defp require_authenticated_user(conn, _opts) do
    if get_session(conn, :auth_token) do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: "/login")
      |> halt()
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", GiolotrelloClientWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:giolotrello_client, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GiolotrelloClientWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
