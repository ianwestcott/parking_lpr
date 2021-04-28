defmodule ParkingLpr.Parkpow do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: [:id, :data, :time_received, :time_sent]}
  schema "parkpows" do
    field :data, :map
    field :time_received, :utc_datetime
    field :time_sent, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(parkpow, attrs) do
    parkpow
    |> cast(attrs, [:data, :time_sent, :time_received])
    |> validate_required([:data, :time_sent, :time_received])
  end
end
