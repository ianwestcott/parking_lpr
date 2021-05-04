defmodule ParkingLprWeb.ApiControllerTest do
  use ParkingLprWeb.ConnCase
  alias ParkingLprWeb.Router.Helpers, as: Routes
  alias ParkingLprWeb.Endpoint

  @create_attrs %{
    data: %{test: "data"} |> Jason.encode() |> elem(1),
    source: "ipsum"
  }

  describe "index" do
    test "Get list of empty events", %{conn: conn} do
      conn = get(conn, Routes.api_path(Endpoint, :index))
      assert json_response(conn, 200)["events"]==[]
    end
  end

  describe "show" do
    test "Get event with invalid id", %{conn: conn} do
      conn = get(conn, Routes.api_path(conn, :show, "123"))
      assert %{"error"=> "Elixir.Ecto.Query.CastError"} = json_response(conn, 404)
    end
  end

  describe "create" do
    test "Create event when data is valid", %{conn: conn} do
      # Create Item
      conn = post(conn, Routes.api_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      # Check it was created correctly
      conn = get(conn, Routes.api_path(conn, :show, id))
      assert %{
        "id" => id,
        "data" => %{"test"=> "data"},
        "source" => "ipsum",
      } = json_response(conn, 200)

      # Check item is in index
      conn = get(conn, Routes.api_path(Endpoint, :index))
      assert json_response(conn, 200)["events"]==[id]
    end
  end
end
