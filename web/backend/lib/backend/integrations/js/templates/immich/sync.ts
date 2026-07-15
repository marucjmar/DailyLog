import type { Ctx, SyncResult } from "../../template.ts";

// Types
export type State = { apiKey: string; host: string };

export async function sync(ctx: Ctx<State>): Promise<SyncResult> {
  return { events: [], continuation: undefined };
}
