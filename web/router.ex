defmodule UnitConverter.Router do
  use UnitConverter.Web, :router

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

  scope "/", UnitConverter do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", UnitConverter do
    pipe_through :api

    get "/convert", PageController, :do_convert
    get "/update-conversions", PageController, :update_conversions
  end
end
