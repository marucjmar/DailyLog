defmodule Backend.DaysFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Days` context.
  """

  @doc """
  Generate a day.
  """
  def day_fixture(attrs \\ %{}) do
    {:ok, day} =
      attrs
      |> Enum.into(%{
        activities_count: 42,
        date: ~D[2026-06-06],
        events_count: 42,
        photos_count: 42,
        summary: "some summary",
        tasks_count: 42,
        timeline: %{},
        user_id: 42
      })
      |> Backend.Days.create_day()

    day
  end
end
