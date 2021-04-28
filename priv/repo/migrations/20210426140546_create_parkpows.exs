defmodule ParkingLpr.Repo.Migrations.CreateParkpows do
  use Ecto.Migration

  def change do
    create table(:parkpows, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :data, :map
      add :time_sent, :utc_datetime
      add :time_received, :utc_datetime

      timestamps()
    end

  end
end
