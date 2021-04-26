defmodule ParkingLprWeb.ApiController do
  use ParkingLprWeb, :controller
  alias ParkingLpr.{Repo, Event}
  require Logger
  import Ecto.Query

  # TODO: move ecto operations to seperate file
  @doc """
  GET /events Retutrns list of all events in database
  """
  def index(conn, _params) do
    # Get list of all event IDs
    Logger.info("GET /events: Getting list of events")
    event_ids = Repo.all(from e in Event, select: e.id)

    # Count number of events
    Logger.info("GET /events: Counting list of events")
    event_count = Repo.one(from e in Event, select: count(e.id))

    # Return JSON Object
    Logger.info("GET /events: Returning response")
    json(conn, %{
      count: event_count,
      events: event_ids
    })
  end

  @doc """
  Returns an event, associated LPR lookups, and s3 image from given eventID

  ## Sample Return:
    {
      event : {Event data}
      image: Base64 encoded image
      lpr1 : {LPR software data...}
      lpr2 : ...
      ...
    }
  # TODO Fall back in case no image is found
  """
  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    # Lookup event data
    Logger.info("GET /events/#{id}: Looking up event")
    event = Repo.one(from e in Event, where: e.id == ^id)

    # Lookup AWS image
    Logger.info("GET /events/#{id}: Looking up AWS image")
    {:ok, aws_response} = ExAws.S3.get_object(System.get_env("AWS_BUCKET"), "test/#{id}.png")
    |> ExAws.request()

    # Return JSON Object
    Logger.info("GET /events/#{id}: Retuning response")
    json(conn, %{event: event, image: Base.encode64(aws_response.body)})
  end

  @doc """
  POST /events Adds a event, returns event id

  # TODO handle missing upload
  # TODO handle missing data
  # TODO handle un able to parse json data
  # TODO handle missing source
  # TODO use env variable for AWS object folder
  # TODO deal with different file types, png, jpg, ect...
  """
  @spec create(Plug.Conn.t(), any) :: Plug.Conn.t()
  def create(conn, _params) do
    # Get response body from conn
    {:ok, body} = Map.fetch(conn, :body_params)

    # Get upload, data and source from body
    Logger.info("POST /events: Getting upload, data and source from body")
    {:ok, upload} = Map.fetch(body, "upload")
    {:ok, data} = Map.fetch(body, "data")
    {:ok, source} = Map.fetch(body, "source")

    # decode JSON for storage
    Logger.info("POST /events: Decoding JSON data")
    {:ok, json_data}= Jason.decode(data)

    # Log time and then insert Event
    Logger.info("POST /events: Inserting Event")
    ts = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, new_event} = Repo.insert(%Event{
      source: source,
      data: json_data,
      timestamp: ts,
    })
    new_event_id = new_event.id


    # Read binary data from upload
    Logger.info("POST /events: Reading file binary")
    {:ok, file_binary} = File.read(upload.path)

    # Upload image to S3
    Logger.info("POST /events: Uploading image to S3")
    ExAws.S3.put_object(System.get_env("AWS_BUCKET"), "test/#{new_event_id}.png", file_binary)
    |> ExAws.request()

    Logger.info("POST /events: Returning response for event #{new_event_id}")
    json(conn, %{id: new_event_id})
  end

end
