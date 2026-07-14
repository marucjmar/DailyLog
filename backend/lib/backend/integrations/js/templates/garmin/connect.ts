import gc, { IGarminTokens } from 'npm:garmin-connect-nexxt@1.6.19';

const { GarminConnect } = gc;

export async function connect(ctx: { inputs: Record<string, unknown> }, io: {
  progress: (data: unknown) => void;
  requestInput: (schema: unknown) => Promise<{ code: string }>;
}): Promise<{ session: IGarminTokens }> {
  const GCClient = new GarminConnect({
    username: ctx.inputs.username,
    password: ctx.inputs.password,
    mfaHandler: io.requestInput("mfa").then((input) => input.code),
  });

  try {
    await GCClient.login();
  } catch (err: unknown) {
    throw new Error(`Garmin Connect login error: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
  
  return { session: GCClient.exportToken() };
}
