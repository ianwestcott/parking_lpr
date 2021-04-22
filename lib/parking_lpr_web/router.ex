defmodule ParkingLprWeb.Router do
  use ParkingLprWeb, :router

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

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  scope "/", ParkingLprWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Plug function
  defp ensure_authenticated(conn, _opts) do
    # TODO Check authentication token
    # current_user_id = get_session(conn, :current_user_id)
    # current_user_id = true
    # if current_user_id do
    #   conn
    # else
    #   conn
    #   |> put_status(:unauthorized)
    #   |> render("401.json", message: "Unauthenticated user")
    #   |> halt()
    # end
    conn
  end

  # Other scopes may use custom stacks.
  scope "/events", ParkingLprWeb do
    pipe_through [:api, :api_auth]
    # get "/", ApiController, :index
    # get "/:id", ApiController, :show
    resources "/", ApiController, only: [:index, :show, :create]
  end

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
      live_dashboard "/dashboard", metrics: ParkingLprWeb.Telemetry
    end
  end
end
