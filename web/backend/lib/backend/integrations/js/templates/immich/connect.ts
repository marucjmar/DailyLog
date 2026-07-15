import type { State } from "./sync.ts";

export async function connect(
  config: { apiKey: string; host: string },
  io: {
    progress: (data: unknown) => void;
    requestInput: (schema: unknown) => Promise<State>;
  },
): Promise<State> {
  const res = await fetch(`${config.host}/api/users/me`, {
    headers: {
      "x-api-key": config.apiKey,
      Accept: "application/json",
    },
  });

  if (!res.ok) {
    throw new Error(`Immich API error: ${res.status} ${res.statusText}`);
  }

  return config;
}