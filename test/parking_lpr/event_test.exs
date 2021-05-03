defmodule ParkingLpr.EventTest do
  use ParkingLpr.DataCase
  alias ParkingLpr.Event

  @valid_json "{\"lorem\":\"ipsum\"}"

  describe "Adding Events" do
    test "Add event with invalid json data" do
      assert nil === Event.add_event("this is not json","")
      assert nil === Event.add_event(nil,"")
    end

    test "Add event and check JSON is translated to map" do
      e = Event.add_event(@valid_json, "some_source")
      assert e.data["lorem"] === "ipsum"
    end
  end

  describe "Listing & Counting Events" do
    test "Getting list of events, and event count" do
      # test things are empty
      assert 0 === Event.count_events()
      assert [] === Event.list_event_ids()

      # add item
      e = Event.add_event(@valid_json, "some_source")

      # test things show item
      assert 1 === Event.count_events()
      assert e.id === hd(Event.list_event_ids())
    end
  end

  describe "Getting Events" do
    test "Return nil when event ID doesn't exist" do
      assert nil === Event.get_event("what id")
    end

    test "Create an event, get it by its ID" do
      e = Event.add_event(@valid_json, "some_source")
      assert e.id === hd(Event.list_event_ids())
    end
  end
end
