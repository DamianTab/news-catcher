defmodule CatcherWeb.Router do
  use CatcherWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CatcherWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit, :update]
    put "/users/:id", UserController, :update
    patch "/users/:id", UserController, :patch

    post "/migration", MigrationController, :migration

    resources "/users/:uid/favourites", FavouriteController, except: [:new, :edit, :update]
    delete "/users/:uid/favourites", FavouriteController, :delete_all
    put "/users/:uid/favourites/:fid", FavouriteController, :update
    patch "/users/:uid/favourites/:fid", FavouriteController, :patch

    get "/news", ArticleController, :index
    get "/news/params", ArticleController, :index_params
    get "/news/:id", ArticleController, :show
    delete "/news/", ArticleController, :delete_all
    delete "/news/:id", ArticleController, :delete

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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: CatcherWeb.Telemetry
    end
  end
end
