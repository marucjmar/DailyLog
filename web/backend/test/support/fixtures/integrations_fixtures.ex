defmodule Backend.IntegrationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Integrations` context.
  """

  @doc """
  Generate a integration.
  """
  def integration_fixture(attrs \\ %{}) do
    {:ok, integration} =
      attrs
      |> Enum.into(%{
        config: %{},
        custom_code: "some custom_code",
        enabled: true,
        last_sync_at: ~U[2026-06-06 21:36:00Z],
        name: "some name",
        template_id: "some template_id",
        user_id: 42
      })
      |> Backend.Integrations.create_integration()

    integration
  end

  @doc """
  Generate a integration_template.
  """
  def integration_template_fixture(attrs \\ %{}) do
    {:ok, integration_template} =
      attrs
      |> Enum.into(%{
        compiled_at: ~U[2026-06-14 19:25:00Z],
        compiled_path: "some compiled_path",
        description: "some description",
        input_schema: %{},
        name: "some name",
        slug: "some slug",
        version: "some version"
      })
      |> Backend.Integrations.create_integration_template()

    integration_template
  end

  @doc """
  Generate a connection.
  """
  def connection_fixture(attrs \\ %{}) do
    {:ok, connection} =
      attrs
      |> Enum.into(%{
        compiled_path: "some compiled_path",
        inputs: %{},
        last_error: "some last_error",
        last_synced_at: ~U[2026-06-14 19:26:00Z],
        source_code: "some source_code",
        status: "some status"
      })
      |> Backend.Integrations.create_connection()

    connection
  end

  @doc """
  Generate a integration.
  """
  def integration_fixture(attrs \\ %{}) do
    {:ok, integration} =
      attrs
      |> Enum.into(%{
        compiled_path: "some compiled_path",
        inputs: %{},
        last_error: "some last_error",
        last_synced_at: ~U[2026-06-14 19:26:00Z],
        source_code: "some source_code",
        status: "some status"
      })
      |> Backend.Integrations.create_integration()

    integration
  end

  @doc """
  Generate a sync_log.
  """
  def sync_log_fixture(attrs \\ %{}) do
    {:ok, sync_log} =
      attrs
      |> Enum.into(%{
        duration_ms: 42,
        error: "some error",
        events_count: 42,
        status: "some status"
      })
      |> Backend.Integrations.create_sync_log()

    sync_log
  end
end
