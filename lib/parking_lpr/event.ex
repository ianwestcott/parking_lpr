defmodule ParkingLpr.Event do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias ParkingLpr.{Repo, Event}


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :data, :source, :timestamp]}
  schema "events" do
    field :data, :map
    field :source, :string
    field :timestamp, :utc_datetime

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:source, :data, :timestamp])
    |> validate_required([:source, :data, :timestamp])
  end
  @doc """
    Given an Event identifier returns Event
  """
  def get_event(id) do
    Repo.one(from e in Event, where: e.id == ^id)
  rescue
    Ecto.Query.CastError -> nil
  end

  @doc """
    Creates an Event in the DB from body_params
  """
  def add_event(data, source) do

    {:ok, json_data}= Jason.decode(data)

    ts = DateTime.utc_now() |> DateTime.truncate(:second)

    {:ok, new_event} = Repo.insert(%Event{
      source: source,
      data: json_data,
      timestamp: ts,
    })
    new_event

  rescue
    _-> nil
  end

  @doc """
    Returns list of Event ids
  """
  def list_event_ids() do
    Repo.all(from e in Event, select: e.id)
  end

  @doc """
    Return number of total Events
  """
  def count_events() do
    Repo.one(from e in Event, select: count(e.id))
  end
end
