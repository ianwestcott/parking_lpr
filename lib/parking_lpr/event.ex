defmodule ParkingLpr.Event do
  use Ecto.Schema
  import Ecto.Changeset

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
end
