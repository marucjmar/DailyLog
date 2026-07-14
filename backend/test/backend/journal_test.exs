defmodule Backend.JournalTest do
  use Backend.DataCase

  alias Backend.Journal

  describe "events" do
    alias Backend.Journal.Event

    import Backend.JournalFixtures

    @invalid_attrs %{timestamp: nil, type: nil, source: nil, user_id: nil, payload: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Journal.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Journal.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{timestamp: ~U[2026-06-06 20:41:00Z], type: "some type", source: "some source", user_id: 42, payload: %{}}

      assert {:ok, %Event{} = event} = Journal.create_event(valid_attrs)
      assert event.timestamp == ~U[2026-06-06 20:41:00Z]
      assert event.type == "some type"
      assert event.source == "some source"
      assert event.user_id == 42
      assert event.payload == %{}
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journal.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{timestamp: ~U[2026-06-07 20:41:00Z], type: "some updated type", source: "some updated source", user_id: 43, payload: %{}}

      assert {:ok, %Event{} = event} = Journal.update_event(event, update_attrs)
      assert event.timestamp == ~U[2026-06-07 20:41:00Z]
      assert event.type == "some updated type"
      assert event.source == "some updated source"
      assert event.user_id == 43
      assert event.payload == %{}
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Journal.update_event(event, @invalid_attrs)
      assert event == Journal.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Journal.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Journal.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Journal.change_event(event)
    end
  end

  describe "assets" do
    alias Backend.Journal.Asset

    import Backend.JournalFixtures

    @invalid_attrs %{size: nil, type: nil, checksum: nil, metadata: nil, user_id: nil, storage_key: nil, mime_type: nil}

    test "list_assets/0 returns all assets" do
      asset = asset_fixture()
      assert Journal.list_assets() == [asset]
    end

    test "get_asset!/1 returns the asset with given id" do
      asset = asset_fixture()
      assert Journal.get_asset!(asset.id) == asset
    end

    test "create_asset/1 with valid data creates a asset" do
      valid_attrs = %{size: 42, type: "some type", checksum: "some checksum", metadata: %{}, user_id: 42, storage_key: "some storage_key", mime_type: "some mime_type"}

      assert {:ok, %Asset{} = asset} = Journal.create_asset(valid_attrs)
      assert asset.size == 42
      assert asset.type == "some type"
      assert asset.checksum == "some checksum"
      assert asset.metadata == %{}
      assert asset.user_id == 42
      assert asset.storage_key == "some storage_key"
      assert asset.mime_type == "some mime_type"
    end

    test "create_asset/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journal.create_asset(@invalid_attrs)
    end

    test "update_asset/2 with valid data updates the asset" do
      asset = asset_fixture()
      update_attrs = %{size: 43, type: "some updated type", checksum: "some updated checksum", metadata: %{}, user_id: 43, storage_key: "some updated storage_key", mime_type: "some updated mime_type"}

      assert {:ok, %Asset{} = asset} = Journal.update_asset(asset, update_attrs)
      assert asset.size == 43
      assert asset.type == "some updated type"
      assert asset.checksum == "some updated checksum"
      assert asset.metadata == %{}
      assert asset.user_id == 43
      assert asset.storage_key == "some updated storage_key"
      assert asset.mime_type == "some updated mime_type"
    end

    test "update_asset/2 with invalid data returns error changeset" do
      asset = asset_fixture()
      assert {:error, %Ecto.Changeset{}} = Journal.update_asset(asset, @invalid_attrs)
      assert asset == Journal.get_asset!(asset.id)
    end

    test "delete_asset/1 deletes the asset" do
      asset = asset_fixture()
      assert {:ok, %Asset{}} = Journal.delete_asset(asset)
      assert_raise Ecto.NoResultsError, fn -> Journal.get_asset!(asset.id) end
    end

    test "change_asset/1 returns a asset changeset" do
      asset = asset_fixture()
      assert %Ecto.Changeset{} = Journal.change_asset(asset)
    end
  end
end
