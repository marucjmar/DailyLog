defmodule BackendWeb.API.IntegrationsController do
  use BackendWeb, :controller

  def connect(conn, %{"integration" => integration}) do
    html(conn, """
    <!doctype html>
    <html lang="pl">
      <head>
        <meta charset="utf-8" />
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1"
        />

        <title>Integracja Garmin</title>

        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
      </head>

      <body>
        <div id="app">
          <main class="container">
    <article>
    <header>
      <h2>Garmin</h2>
    </header>

    <form @submit.prevent="connectIntegration">
      <label>
        Username
        <input
          v-model="form.username"
          type="text">
      </label>

      <label>
        Password
        <input
          v-model="form.password"
          type="password">
      </label>

      <button :aria-busy="running">
        Connect
      </button>
    </form>

    <article v-if="result">
      <pre>{{ formatValue(result) }}</pre>
    </article>
    </article>
    </main>
        </div>

        <script type="module">
          import { Socket } from "https://esm.sh/phoenix";

          import {
            createApp,
            ref,
            reactive,
            computed
          } from "https://unpkg.com/vue@3/dist/vue.esm-browser.js";

          class RemoteExecutor {
            id;
            socket;
            channel;
            execution;

            constructor(integration) {
              this.id = crypto.randomUUID();
              this.socket = new Socket("/socket/integration", {});
              this.socket.connect();
              this.channel = this.socket.channel(`integration:${integration}`, { execution_id: this.id });

              this.channel.join();
            }

            execute(functionName, payload) {
              this.execution = new Promise((resolve, reject) => {
                this.channel.on("done", (response) => {
                  resolve(response)
                  this.terminate();
                });

                this.channel.on("error", (response) => {
                  reject(response);
                  this.terminate();
                });

                this.channel.push("execute", { id: this.id, function: functionName, payload: payload });
              });

              return this;
            }

            submitInput(id, inputs) {
              this.channel.push("submit_input", { execution_id: this.id, id: id, inputs: inputs });
            }

            onInputRequest(schema, callback) {
              this.channel.on("request_input", (payload) => {
                if (payload.schema === schema) {
                  callback(payload);
                }
              });

              return this;
            }

            onDone(callback) {
              this.execution.then((response) => callback(response));

              return this;
            }

            onError(callback) {
              this.execution.catch((response) => callback(response));

              return this;
            }

            terminate() {
              this.channel.push("terminate_execution", {id: this.id});
              this.channel.leave();
            }
          }

          const integration = "Garmin";
          createApp({
            setup() {
              const connected = ref(false);
              const running = ref(false);
              const result = ref(null);
              const error = ref(null);

              const form = reactive({
                username: "",
                password: ""
              });

              const buttonLabel = computed(() => {
                if (!connected.value) {
                  return "Łączenie…";
                }

                if (running.value) {
                  return "Trwa łączenie…";
                }

                return "Połącz";
              });

              function connectIntegration() {
                const executor = new RemoteExecutor(integration);

                if (running.value) {
                  return;
                }

                running.value = true;
                result.value = null;
                error.value = null;

                executor
                  .execute("connect", {
                    username: form.username,
                    password: form.password
                  })
                  .onInputRequest("mfax", payload => {
                    const userInput = prompt("Wprowadź kod MFA:");

                    if (
                      userInput === null ||
                      userInput.trim() === ""
                    ) {
                      error.value = {
                        message: "Nie podano kodu MFA."
                      };

                      executor.terminate();

                      running.value = false;
                      return;
                    }

                    executor.submitInput(payload.id, {
                      code: userInput.trim()
                    });
                  })
                  .onDone(response => {
                    console.log('done')
                    running.value = false;
                    result.value = response;
                  })
                  .onError(response => {
                    console.log('error')
                    running.value = false;
                    result.value = response;
                  });
              }

              function formatValue(value) {
                if (typeof value === "string") {
                  return value;
                }

                return JSON.stringify(value, null, 2);
              }

              return {
                integration,
                connected,
                running,
                result,
                error,
                form,
                buttonLabel,
                connectIntegration,
                formatValue
              };
            }
          }).mount("#app");
        </script>
      </body>
    </html>
    """)
  end
end
