defmodule ParkingLprWeb.ApiController do
  use ParkingLprWeb, :controller

  def index(conn, _params) do
    # TODO: return all events
    IO.inspect(conn, label: "conn:")
    json(conn, %{id: "INDEX"})
  end

  def show(conn, %{"id" => id}) do
    # TODO: return event by id param
    IO.inspect(conn, label: "conn:")
    json(conn, %{id: id})
  end

  @spec create(Plug.Conn.t(), any) :: Plug.Conn.t()
  def create(conn, _params) do
    # TODO: do something with input
    # TODO: response

    {:ok, body} = Map.fetch(conn, :body_params)
    IO.inspect(body,label: "body")

    Map.fetch(body, "upload")
    |> IO.inspect(label: "upload")

    {:ok, data} = Map.fetch(body, "data")
    IO.inspect(data, label: "data")

    {:ok, json}= Jason.decode(data)
    IO.inspect(json, label: "json")
    IO.puts(json["frame"]["aspect_ration"])

    json(conn, %{resp: "created thing"})

  end

end
