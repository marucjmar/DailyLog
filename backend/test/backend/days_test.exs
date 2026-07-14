defmodule Backend.DaysTest do
  use Backend.DataCase

  alias Backend.Days

  describe "days" do
    alias Backend.Days.Day

    import Backend.DaysFixtures

    @invalid_attrs %{
      date: nil,
      user_id: nil,
      events_count: nil,
      photos_count: nil,
      activities_count: nil,
      tasks_count: nil,
      timeline: nil,
      summary: nil
    }

    test "list_days/0 returns all days" do
      day = day_fixture()
      assert Days.list_days() == [day]
    end

    test "get_day!/1 returns the day with given id" do
      day = day_fixture()
      assert Days.get_day!(day.id) == day
    end

    test "create_day/1 with valid data creates a day" do
      valid_attrs = %{
        date: ~D[2026-06-06],
        user_id: 42,
        events_count: 42,
        photos_count: 42,
        activities_count: 42,
        tasks_count: 42,
        timeline: %{},
        summary: "some summary"
      }

      assert {:ok, %Day{} = day} = Days.create_day(valid_attrs)
      assert day.date == ~D[2026-06-06]
      assert day.user_id == 42
      assert day.events_count == 42
      assert day.photos_count == 42
      assert day.activities_count == 42
      assert day.tasks_count == 42
      assert day.timeline == %{}
      assert day.summary == "some summary"
    end

    test "create_day/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Days.create_day(@invalid_attrs)
    end

    test "update_day/2 with valid data updates the day" do
      day = day_fixture()

      update_attrs = %{
        date: ~D[2026-06-07],
        user_id: 43,
        events_count: 43,
        photos_count: 43,
        activities_count: 43,
        tasks_count: 43,
        timeline: %{},
        summary: "some updated summary"
      }

      assert {:ok, %Day{} = day} = Days.update_day(day, update_attrs)
      assert day.date == ~D[2026-06-07]
      assert day.user_id == 43
      assert day.events_count == 43
      assert day.photos_count == 43
      assert day.activities_count == 43
      assert day.tasks_count == 43
      assert day.timeline == %{}
      assert day.summary == "some updated summary"
    end

    test "update_day/2 with invalid data returns error changeset" do
      day = day_fixture()
      assert {:error, %Ecto.Changeset{}} = Days.update_day(day, @invalid_attrs)
      assert day == Days.get_day!(day.id)
    end

    test "delete_day/1 deletes the day" do
      day = day_fixture()
      assert {:ok, %Day{}} = Days.delete_day(day)
      assert_raise Ecto.NoResultsError, fn -> Days.get_day!(day.id) end
    end

    test "change_day/1 returns a day changeset" do
      day = day_fixture()
      assert %Ecto.Changeset{} = Days.change_day(day)
    end
  end
end
