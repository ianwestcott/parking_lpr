defmodule ParkingLpr.EventTest do
  use ParkingLpr.DataCase
  alias ParkingLpr.Event

  @valid_json "{\"lorem\":\"ipsum\"}"

  describe "Adding Events" do
    test "Add event with invalid json data" do
      # Checks for invalid json
      assert {:error, %Jason.DecodeError{
        data: "this is not json",
        position: 0
      }} == Event.add_event("this is not json","")
    end

    test "Add event with nil data" do
      # makes sure we can have nil json
      {:ok, e} = Event.add_event(nil, "lorem")
      assert nil == e.data
    end

    test "Add event and check json is translated to map" do
      assert {:ok, %Event{data: %{"lorem" => "ipsum"}}} = Event.add_event(@valid_json, "some_source")
    end
  end

  describe "Listing & Counting Events" do
    test "Getting list of events, and event count" do
      # test things are empty
      assert 0 == Event.count_events()
      assert [] == Event.list_event_ids()

      # add item
      {:ok, e} = Event.add_event(@valid_json, "some_source")

      # test things show item
      assert 1 == Event.count_events()
      assert e.id == hd(Event.list_event_ids())
    end
  end

  describe "Getting Events" do
    test "Return nil when event ID doesn't exist" do
      assert Ecto.Query.CastError == Event.get_event("what id")
    end

    test "Create an event, get it by its ID" do
      {:ok, e} = Event.add_event(@valid_json, "some_source")
      assert Event.get_event(e.id) == e
    end
  end
end
