defmodule ParkingLprWeb.ApiController do
  use ParkingLprWeb, :controller
  alias ParkingLpr.{Event}
  alias ParkingLprWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    json(conn, %{
      count: Event.count_events(),
      events: Event.list_event_ids()
    })
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    case Event.get_event(id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{})
      id ->
        json(conn,id)
    end
  end

  @spec create(Plug.Conn.t(), any) :: Plug.Conn.t()
  def create(conn, _params) do
    {:ok, body_params} = Map.fetch(conn, :body_params)
    case Event.add_event(body_params["data"], body_params["source"]) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{})
      event ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_path(conn, :show, event))
        |> json(event)
    end
  end
end
