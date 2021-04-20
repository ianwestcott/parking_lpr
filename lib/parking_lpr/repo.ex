defmodule ParkingLpr.Repo do
  use Ecto.Repo,
    otp_app: :parking_lpr,
    adapter: Ecto.Adapters.Postgres
end
