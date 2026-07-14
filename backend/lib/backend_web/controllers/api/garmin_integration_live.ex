defmodule User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username
    field :password
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
  end
end

defmodule BackendWeb.API.GarminIntegrationLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div>
    <.form for={@form} id="my-form" phx-change="validate" phx-submit="save">
      <div>
        <.input type="text" field={@form[:username]} />
      </div>
      <div>
        <.input type="password" field={@form[:password]} />
      </div>

      <button>Save</button>
    </.form>
    </div>

      <%= if @waiting_for_input do %>
        <div>
          <p>Program oczekuje na dodatkowe dane.</p>

          <.form for={%{}} as={:runner_input} phx-submit="send_input">
            <input
              type="text"
              name="runner_input[value]"
              placeholder="Wprowadź dane"
            />

            <button type="submit">Wyślij</button>
          </.form>
        </div>
      <% end %>

      <%= if @success do %>
        <div>
          <p>Program zakończył się sukcesem.</p>
          <pre><%= inspect(@result) %></pre>
        </div>
      <% end %>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:form, to_form(User.changeset(%User{}, %{})))
      |> assign(:waiting_for_input, false)
      |> assign(:success, false)

    {:ok, socket}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = User.changeset(%User{}, params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end


  def handle_event("save", %{"user" => params}, socket) do
    case CodeRunner.run_file(
          "/Users/marcin/development/daily-log/backend/lib/backend/integrations/js/templates/garmin/connect.ts",
          %{inputs: params},
          "connect"
        ) do
      {:ok, %{port: port}} ->
        {:noreply,
        socket
        |> assign(:port, port)
        |> assign(:running, true)
        |> assign(:waiting_for_input, false)
        |> assign(:result, nil)
        |> assign(:error, nil)}

      {:error, reason} ->
        {:noreply,
        socket
        |> assign(:running, false)
        |> assign(:error, reason)}
    end
  end

  def handle_event(
        "send_input",
        %{"runner_input" => %{"value" => runner_input}},
        %{assigns: %{port: port}} = socket
      )
      when not is_nil(port) do

    CodeRunner.submit_input(port, "mfa", %{code: runner_input})

    {:noreply,
    socket
    |> assign(:waiting_for_input, false)
    |> assign(:request_input, nil)}
  end


  attr :type, :string, default: "text"
  attr :field, Phoenix.HTML.FormField
  attr :rest, :global

  def input(assigns) do
    ~H"""
    <input type="text" name={@field.name} id={@field.id} value={@field.value} />
    <p :for={msg <- @field.errors} :if={used_input?(@field)} class="text-red-600 text-sm">
      <%= translate_error(msg) %>
    </p>
    """
  end

  def error(assigns) do
    ~H"""
    <p class="text-red-600 text-sm"><%= render_slot(@inner_block) || @children %></p>
    """
  end

  def translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  def handle_info(
        {port, {:data, {:eol, line}}},
        %{assigns: %{port: port}} = socket
      ) do
    case CodeRunner.decode_line(line) do
      {:ok, %{"type" => "progress"} = message} ->
        {:noreply, assign(socket, :progress, message)}

      {:ok, %{"type" => "request_input"} = message} ->
        {:noreply,
         socket
         |> assign(:waiting_for_input, true)
         |> assign(:request_input, message)}

      {:ok, %{"type" => "done", "result" => result}} ->
        {:noreply,
         socket
         |> assign(:running, false)
         |> assign(:success, true)
         |> assign(:waiting_for_input, false)
         |> assign(:result, result)}

      {:ok, %{"type" => "error"} = error} ->
        {:noreply,
         socket
         |> assign(:running, false)
         |> assign(:waiting_for_input, false)
         |> assign(:error, error)}

      {:error, reason} ->
        {:noreply, assign(socket, :error, reason)}
    end
  end

  def handle_info(
        {port, {:exit_status, status}},
        %{assigns: %{port: port}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:port, nil)
     |> assign(:running, false)
     |> assign(:exit_status, status)}
  end

  # Opcjonalnie: ignorowanie wiadomości ze starych portów
  def handle_info({_port, {:data, _data}}, socket) do
    {:noreply, socket}
  end

  def handle_info({_port, {:exit_status, _status}}, socket) do
    {:noreply, socket}
  end
end
