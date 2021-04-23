defmodule ParkingLprWeb.ApiController do
  use ParkingLprWeb, :controller
  alias ParkingLpr.{Repo, Event}

  import Ecto.Query

  # TODO: move ecto operations to seperate file

  def index(conn, _params) do
    # IO.inspect(conn, label: "conn:")
    event_ids = Repo.all(from e in Event, select: e.id)
    event_count = Repo.one(from e in Event, select: count(e.id))
    json(conn, %{
      count: event_count,
      events: event_ids
    })
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    event = Repo.one(from e in Event, where: e.id == ^id)
    IO.inspect(event, label: "found: ")
    json(conn, %{event: event})
  end

  @spec create(Plug.Conn.t(), any) :: Plug.Conn.t()
  def create(conn, _params) do
    {:ok, body} = Map.fetch(conn, :body_params)
    # IO.inspect(body,label: "body")

    Map.fetch(body, "upload")
    |> IO.inspect(label: "upload")

    {:ok, data} = Map.fetch(body, "data")
    {:ok, source} = Map.fetch(body, "source")

    {:ok, json_data}= Jason.decode(data)
    # IO.inspect(json_data, label: "json")

    ts = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, new_event} = Repo.insert(%Event{
      source: source,
      data: json_data,
      timestamp: ts,
    })
    json(conn, %{id: new_event.id})

  end

end
