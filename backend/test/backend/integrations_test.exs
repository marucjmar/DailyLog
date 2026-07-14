defmodule Backend.IntegrationsTest do
  use Backend.DataCase

  alias Backend.Integrations

  describe "integrations" do
    alias Backend.Integrations.Integration

    import Backend.IntegrationsFixtures

    @invalid_attrs %{enabled: nil, name: nil, config: nil, user_id: nil, template_id: nil, custom_code: nil, last_sync_at: nil}

    test "list_integrations/0 returns all integrations" do
      integration = integration_fixture()
      assert Integrations.list_integrations() == [integration]
    end

    test "get_integration!/1 returns the integration with given id" do
      integration = integration_fixture()
      assert Integrations.get_integration!(integration.id) == integration
    end

    test "create_integration/1 with valid data creates a integration" do
      valid_attrs = %{enabled: true, name: "some name", config: %{}, user_id: 42, template_id: "some template_id", custom_code: "some custom_code", last_sync_at: ~U[2026-06-06 21:36:00Z]}

      assert {:ok, %Integration{} = integration} = Integrations.create_integration(valid_attrs)
      assert integration.enabled == true
      assert integration.name == "some name"
      assert integration.config == %{}
      assert integration.user_id == 42
      assert integration.template_id == "some template_id"
      assert integration.custom_code == "some custom_code"
      assert integration.last_sync_at == ~U[2026-06-06 21:36:00Z]
    end

    test "create_integration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_integration(@invalid_attrs)
    end

    test "update_integration/2 with valid data updates the integration" do
      integration = integration_fixture()
      update_attrs = %{enabled: false, name: "some updated name", config: %{}, user_id: 43, template_id: "some updated template_id", custom_code: "some updated custom_code", last_sync_at: ~U[2026-06-07 21:36:00Z]}

      assert {:ok, %Integration{} = integration} = Integrations.update_integration(integration, update_attrs)
      assert integration.enabled == false
      assert integration.name == "some updated name"
      assert integration.config == %{}
      assert integration.user_id == 43
      assert integration.template_id == "some updated template_id"
      assert integration.custom_code == "some updated custom_code"
      assert integration.last_sync_at == ~U[2026-06-07 21:36:00Z]
    end

    test "update_integration/2 with invalid data returns error changeset" do
      integration = integration_fixture()
      assert {:error, %Ecto.Changeset{}} = Integrations.update_integration(integration, @invalid_attrs)
      assert integration == Integrations.get_integration!(integration.id)
    end

    test "delete_integration/1 deletes the integration" do
      integration = integration_fixture()
      assert {:ok, %Integration{}} = Integrations.delete_integration(integration)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_integration!(integration.id) end
    end

    test "change_integration/1 returns a integration changeset" do
      integration = integration_fixture()
      assert %Ecto.Changeset{} = Integrations.change_integration(integration)
    end
  end

  describe "integration_templates" do
    alias Backend.Integrations.IntegrationTemplate

    import Backend.IntegrationsFixtures

    @invalid_attrs %{name: nil, version: nil, description: nil, slug: nil, input_schema: nil, compiled_path: nil, compiled_at: nil}

    test "list_integration_templates/0 returns all integration_templates" do
      integration_template = integration_template_fixture()
      assert Integrations.list_integration_templates() == [integration_template]
    end

    test "get_integration_template!/1 returns the integration_template with given id" do
      integration_template = integration_template_fixture()
      assert Integrations.get_integration_template!(integration_template.id) == integration_template
    end

    test "create_integration_template/1 with valid data creates a integration_template" do
      valid_attrs = %{name: "some name", version: "some version", description: "some description", slug: "some slug", input_schema: %{}, compiled_path: "some compiled_path", compiled_at: ~U[2026-06-14 19:25:00Z]}

      assert {:ok, %IntegrationTemplate{} = integration_template} = Integrations.create_integration_template(valid_attrs)
      assert integration_template.name == "some name"
      assert integration_template.version == "some version"
      assert integration_template.description == "some description"
      assert integration_template.slug == "some slug"
      assert integration_template.input_schema == %{}
      assert integration_template.compiled_path == "some compiled_path"
      assert integration_template.compiled_at == ~U[2026-06-14 19:25:00Z]
    end

    test "create_integration_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_integration_template(@invalid_attrs)
    end

    test "update_integration_template/2 with valid data updates the integration_template" do
      integration_template = integration_template_fixture()
      update_attrs = %{name: "some updated name", version: "some updated version", description: "some updated description", slug: "some updated slug", input_schema: %{}, compiled_path: "some updated compiled_path", compiled_at: ~U[2026-06-15 19:25:00Z]}

      assert {:ok, %IntegrationTemplate{} = integration_template} = Integrations.update_integration_template(integration_template, update_attrs)
      assert integration_template.name == "some updated name"
      assert integration_template.version == "some updated version"
      assert integration_template.description == "some updated description"
      assert integration_template.slug == "some updated slug"
      assert integration_template.input_schema == %{}
      assert integration_template.compiled_path == "some updated compiled_path"
      assert integration_template.compiled_at == ~U[2026-06-15 19:25:00Z]
    end

    test "update_integration_template/2 with invalid data returns error changeset" do
      integration_template = integration_template_fixture()
      assert {:error, %Ecto.Changeset{}} = Integrations.update_integration_template(integration_template, @invalid_attrs)
      assert integration_template == Integrations.get_integration_template!(integration_template.id)
    end

    test "delete_integration_template/1 deletes the integration_template" do
      integration_template = integration_template_fixture()
      assert {:ok, %IntegrationTemplate{}} = Integrations.delete_integration_template(integration_template)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_integration_template!(integration_template.id) end
    end

    test "change_integration_template/1 returns a integration_template changeset" do
      integration_template = integration_template_fixture()
      assert %Ecto.Changeset{} = Integrations.change_integration_template(integration_template)
    end
  end

  describe "connections" do
    alias Backend.Integrations.Connection

    import Backend.IntegrationsFixtures

    @invalid_attrs %{status: nil, source_code: nil, compiled_path: nil, inputs: nil, last_error: nil, last_synced_at: nil}

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()
      assert Integrations.list_connections() == [connection]
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert Integrations.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      valid_attrs = %{status: "some status", source_code: "some source_code", compiled_path: "some compiled_path", inputs: %{}, last_error: "some last_error", last_synced_at: ~U[2026-06-14 19:26:00Z]}

      assert {:ok, %Connection{} = connection} = Integrations.create_connection(valid_attrs)
      assert connection.status == "some status"
      assert connection.source_code == "some source_code"
      assert connection.compiled_path == "some compiled_path"
      assert connection.inputs == %{}
      assert connection.last_error == "some last_error"
      assert connection.last_synced_at == ~U[2026-06-14 19:26:00Z]
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()
      update_attrs = %{status: "some updated status", source_code: "some updated source_code", compiled_path: "some updated compiled_path", inputs: %{}, last_error: "some updated last_error", last_synced_at: ~U[2026-06-15 19:26:00Z]}

      assert {:ok, %Connection{} = connection} = Integrations.update_connection(connection, update_attrs)
      assert connection.status == "some updated status"
      assert connection.source_code == "some updated source_code"
      assert connection.compiled_path == "some updated compiled_path"
      assert connection.inputs == %{}
      assert connection.last_error == "some updated last_error"
      assert connection.last_synced_at == ~U[2026-06-15 19:26:00Z]
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()
      assert {:error, %Ecto.Changeset{}} = Integrations.update_connection(connection, @invalid_attrs)
      assert connection == Integrations.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = Integrations.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = Integrations.change_connection(connection)
    end
  end

  describe "integrations" do
    alias Backend.Integrations.Integration

    import Backend.IntegrationsFixtures

    @invalid_attrs %{status: nil, source_code: nil, compiled_path: nil, inputs: nil, last_error: nil, last_synced_at: nil}

    test "list_integrations/0 returns all integrations" do
      integration = integration_fixture()
      assert Integrations.list_integrations() == [integration]
    end

    test "get_integration!/1 returns the integration with given id" do
      integration = integration_fixture()
      assert Integrations.get_integration!(integration.id) == integration
    end

    test "create_integration/1 with valid data creates a integration" do
      valid_attrs = %{status: "some status", source_code: "some source_code", compiled_path: "some compiled_path", inputs: %{}, last_error: "some last_error", last_synced_at: ~U[2026-06-14 19:26:00Z]}

      assert {:ok, %Integration{} = integration} = Integrations.create_integration(valid_attrs)
      assert integration.status == "some status"
      assert integration.source_code == "some source_code"
      assert integration.compiled_path == "some compiled_path"
      assert integration.inputs == %{}
      assert integration.last_error == "some last_error"
      assert integration.last_synced_at == ~U[2026-06-14 19:26:00Z]
    end

    test "create_integration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_integration(@invalid_attrs)
    end

    test "update_integration/2 with valid data updates the integration" do
      integration = integration_fixture()
      update_attrs = %{status: "some updated status", source_code: "some updated source_code", compiled_path: "some updated compiled_path", inputs: %{}, last_error: "some updated last_error", last_synced_at: ~U[2026-06-15 19:26:00Z]}

      assert {:ok, %Integration{} = integration} = Integrations.update_integration(integration, update_attrs)
      assert integration.status == "some updated status"
      assert integration.source_code == "some updated source_code"
      assert integration.compiled_path == "some updated compiled_path"
      assert integration.inputs == %{}
      assert integration.last_error == "some updated last_error"
      assert integration.last_synced_at == ~U[2026-06-15 19:26:00Z]
    end

    test "update_integration/2 with invalid data returns error changeset" do
      integration = integration_fixture()
      assert {:error, %Ecto.Changeset{}} = Integrations.update_integration(integration, @invalid_attrs)
      assert integration == Integrations.get_integration!(integration.id)
    end

    test "delete_integration/1 deletes the integration" do
      integration = integration_fixture()
      assert {:ok, %Integration{}} = Integrations.delete_integration(integration)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_integration!(integration.id) end
    end

    test "change_integration/1 returns a integration changeset" do
      integration = integration_fixture()
      assert %Ecto.Changeset{} = Integrations.change_integration(integration)
    end
  end

  describe "sync_logs" do
    alias Backend.Integrations.SyncLog

    import Backend.IntegrationsFixtures

    @invalid_attrs %{error: nil, status: nil, duration_ms: nil, events_count: nil}

    test "list_sync_logs/0 returns all sync_logs" do
      sync_log = sync_log_fixture()
      assert Integrations.list_sync_logs() == [sync_log]
    end

    test "get_sync_log!/1 returns the sync_log with given id" do
      sync_log = sync_log_fixture()
      assert Integrations.get_sync_log!(sync_log.id) == sync_log
    end

    test "create_sync_log/1 with valid data creates a sync_log" do
      valid_attrs = %{error: "some error", status: "some status", duration_ms: 42, events_count: 42}

      assert {:ok, %SyncLog{} = sync_log} = Integrations.create_sync_log(valid_attrs)
      assert sync_log.error == "some error"
      assert sync_log.status == "some status"
      assert sync_log.duration_ms == 42
      assert sync_log.events_count == 42
    end

    test "create_sync_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_sync_log(@invalid_attrs)
    end

    test "update_sync_log/2 with valid data updates the sync_log" do
      sync_log = sync_log_fixture()
      update_attrs = %{error: "some updated error", status: "some updated status", duration_ms: 43, events_count: 43}

      assert {:ok, %SyncLog{} = sync_log} = Integrations.update_sync_log(sync_log, update_attrs)
      assert sync_log.error == "some updated error"
      assert sync_log.status == "some updated status"
      assert sync_log.duration_ms == 43
      assert sync_log.events_count == 43
    end

    test "update_sync_log/2 with invalid data returns error changeset" do
      sync_log = sync_log_fixture()
      assert {:error, %Ecto.Changeset{}} = Integrations.update_sync_log(sync_log, @invalid_attrs)
      assert sync_log == Integrations.get_sync_log!(sync_log.id)
    end

    test "delete_sync_log/1 deletes the sync_log" do
      sync_log = sync_log_fixture()
      assert {:ok, %SyncLog{}} = Integrations.delete_sync_log(sync_log)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_sync_log!(sync_log.id) end
    end

    test "change_sync_log/1 returns a sync_log changeset" do
      sync_log = sync_log_fixture()
      assert %Ecto.Changeset{} = Integrations.change_sync_log(sync_log)
    end
  end
end
