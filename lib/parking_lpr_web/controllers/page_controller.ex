defmodule ParkingLprWeb.PageController do
  use ParkingLprWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
