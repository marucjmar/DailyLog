defmodule Backend.JournalFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Journal` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        payload: %{},
        source: "some source",
        timestamp: ~U[2026-06-06 20:41:00Z],
        type: "some type",
        user_id: 42
      })
      |> Backend.Journal.create_event()

    event
  end

  @doc """
  Generate a asset.
  """
  def asset_fixture(attrs \\ %{}) do
    {:ok, asset} =
      attrs
      |> Enum.into(%{
        checksum: "some checksum",
        metadata: %{},
        mime_type: "some mime_type",
        size: 42,
        storage_key: "some storage_key",
        type: "some type",
        user_id: 42
      })
      |> Backend.Journal.create_asset()

    asset
  end
end
