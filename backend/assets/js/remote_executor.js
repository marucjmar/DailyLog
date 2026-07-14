import { Socket } from "https://esm.sh/phoenix";

export class RemoteExecutor {
  #id;
  #socket;
  #channel;
  #execution;
  #joinPromise;
  #resolveExecution;
  #rejectExecution;
  #inputHandlers = new Map();
  #terminated = false;

  constructor(integration) {
    this.id = crypto.randomUUID();

    this.socket = new Socket("/socket/integration", {});
    this.socket.connect();

    this.channel = this.socket.channel(
      `integration:${integration}`,
      {
        execution_id: this.id
      }
    );

    this.#registerChannelHandlers();
  }

  join() {
    if (this.#joinPromise) {
      return this.#joinPromise;
    }

    this.#joinPromise = new Promise((resolve, reject) => {
      this.channel
        .join()
        .receive("ok", resolve)
        .receive("error", reject)
        .receive("timeout", () => {
          reject(new Error("Channel join timeout"));
        });
    });

    return this.#joinPromise;
  }

  execute(functionName, payload) {
    if (this.execution) {
      throw new Error("This executor already has an active execution");
    }

    this.execution = new Promise((resolve, reject) => {
      this.#resolveExecution = resolve;
      this.#rejectExecution = reject;

      this.join()
        .then(() => {
          this.channel
            .push("execute", {
              id: this.id,
              function: functionName,
              payload
            })
            .receive("error", response => {
              this.#finishWithError(response);
            })
            .receive("timeout", () => {
              this.#finishWithError(
                new Error("Execution request timeout")
              );
            });
        })
        .catch(error => {
          this.#finishWithError(error);
        });
    });

    return this;
  }

  submitInput(id, inputs) {
    return this.channel.push("submit_input", {
      execution_id: this.id,
      id,
      inputs
    });
  }

  onInputRequest(schema, callback) {
    this.#inputHandlers.set(schema, callback);
    return this;
  }

  onDone(callback) {
    this.#assertExecution();
    this.execution.then(callback).then(() => this.terminate());

    return this;
  }

  onError(callback) {
    this.#assertExecution();
    this.execution.catch(callback).catch(() => this.terminate());

    return this;
  }

  cancel() {
    if (this.#terminated) {
      return;
    }

    this.channel.push("terminate_execution", {
      id: this.id
    });

    this.#finishWithError(
      new Error("Execution cancelled")
    );
  }

  terminate() {
    if (this.#terminated) {
      return;
    }

    this.#terminated = true;
    this.#inputHandlers.clear();

    this.channel.leave();
    this.socket.disconnect();
  }

  #registerChannelHandlers() {
    this.channel.on("request_input", payload => {
      const callback = this.#inputHandlers.get(payload.schema);
      
      if (!callback) {
        this.#finishWithError(
          new Error(`Inputs request schema '${payload.schema}' is unhandled!`)
        );

        return;
      }

      callback(payload);
    });

    this.channel.on("done", response => {
      if (this.#terminated) {
        return;
      }

      this.#resolveExecution?.(response);
      this.terminate();
    });

    this.channel.on("error", response => {
      this.#finishWithError(response);
    });
  }

  #finishWithError(error) {
    if (this.#terminated) {
      return;
    }

    this.#rejectExecution?.(error);
    this.terminate();
  }

  #assertExecution() {
    if (!this.execution) {
      throw new Error(
        "Call execute() before registering completion handlers"
      );
    }
  }
}