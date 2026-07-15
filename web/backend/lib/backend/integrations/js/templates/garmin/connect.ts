import gc from 'npm:garmin-connect-nexxt@1.6.24';
import type { State } from './sync.ts';

const { GarminConnect } = gc;

export async function connect(payload: { username: string; password: string }, io: {
  progress: (data: unknown) => void;
  requestInput: (schema: unknown) => Promise<{ code: string }>;
}): Promise<State> {
  const GCClient = new GarminConnect({
    username: payload.username,
    password: payload.password,
    options: {
      mfaHandler: async () => await io.requestInput("mfa").then((input) => input.code),
    }
  });

  GCClient.httpClient.setNextRequestsDelay(1000);

  try {
    await GCClient.login();
  } catch (err: unknown) {
    throw new Error(`Garmin Connect login error: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
  
  return { session: GCClient.exportToken() };
}
