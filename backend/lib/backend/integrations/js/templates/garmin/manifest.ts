import { TemplateManifest } from "../../template.ts";

export const manifest = {
  id: "garmin",
  name: "Garmin Connect",
  description: "Sync activities from Garmin",
  inputs: {
    password: { type: "string", required: true },
    username: { type: "string", required: true },
  }
} satisfies TemplateManifest;

type MapInput<T> =
  T extends { type: "string" } ? string :
  T extends { type: "number" } ? number :
  never;

export type Inputs = {
  [K in keyof typeof manifest.inputs]:
    MapInput<typeof manifest.inputs[K]>
};