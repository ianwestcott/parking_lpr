defmodule ParkingLpr.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :source, :string
      add :data, :map
      add :timestamp, :utc_datetime

      timestamps()
    end

  end
end
