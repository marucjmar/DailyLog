export type Trigger = "daily_sync" | "sync_all";

export type TState = Record<string, string | number>;

export type Ctx<I, State = TState> = {
  inputs: I;
  trigger: Trigger;
  state: State;
}

export type TemplateManifest = {
  id: string,
  name: string,
  description: string,
  inputs: Record<string, { type: "string" | "number" | "boolean"; required: boolean }>,
}

export type EventTime =
  | { start: number; end?: number }
  | { timestamp: number };
  
export interface BaseEvent {
  source: string;
  time: EventTime;
  unique_hash: string;
  preview_url?: string;
}

export interface PhotoEvent extends BaseEvent {
  type: "photo";

  payload: {
    asset_id: string;
    filename?: string;
    latitude?: number;
    longitude?: number;
    [key: string]: unknown;
  };
}

export interface ActivityEvent extends BaseEvent {
  type: "activity";

  payload: {
    activity_id: string;
    sport?: string;
    gpx?: string;
    distance?: number;
    duration?: number;
    [key: string]: unknown;
  };
}

export interface TaskEvent extends BaseEvent {
  type: "task";

  payload: {
    title: string;
    completed?: boolean;
    [key: string]: unknown;
  };
}

export interface NoteEvent extends BaseEvent {
  type: "note";

  payload: {
    content: string;
    [key: string]: unknown;
  };
}

export type Event =
  | PhotoEvent
  | ActivityEvent
  | TaskEvent
  | NoteEvent;
  
export type SyncResult<ConfinuationState = TState> = {
  events: Event[];
  continuation?: {
    state: ConfinuationState;
    schedule?: {
      runAt?: number;
      delayMs?: number;
    };
  };
};
