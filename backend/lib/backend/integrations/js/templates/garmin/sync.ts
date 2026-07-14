import os from 'node:os';
import fs from 'node:fs';

import gc, { IGarminTokens } from 'npm:garmin-connect-nexxt@1.6.19';
import dayjs from 'npm:dayjs@1.11.21';

import type { ActivityEvent, Ctx, SyncResult } from '../../template.ts';

const { GarminConnect } = gc;

// Utils
const delay = async (delayTime: number) => await new Promise(r => setTimeout(r, delayTime));
const today = dayjs();
const isToday = (time: string) => dayjs(time).isSame(today, 'day');

// Types
export type State = { cursor?: number; session: IGarminTokens };
type Context = Ctx<State>;

export async function sync(ctx: Context): Promise<SyncResult> {
    const GCClient = new GarminConnect();
    GCClient.loadToken(ctx.state.session.oauth1, ctx.state.session.oauth2);

    let activitiesCount = 3;
    const start: number = ctx.state?.cursor ?? 0;

    if (ctx.trigger === 'sync_all') {
      activitiesCount = 5;
    }

    await GCClient.login();
    await delay(1000);

    const activities = await GCClient.getActivities(start, activitiesCount);
    const events: ActivityEvent[] = [];

    let dailySyncContinuation = activities.length > 0;

    for (const activity of activities) {
      //@ts-ignore
      const endTimeGMT = activity.endTimeGMT;
      
      if (ctx.trigger === 'daily_sync' && !isToday(activity.startTimeGMT) && !isToday(endTimeGMT)) {
        dailySyncContinuation = false;
        continue;
      }

      await GCClient.downloadOriginalActivityData(activity, os.tmpdir(), 'gpx');
      const gpx = fs.readFileSync(`${os.tmpdir()}/${activity.activityId}.gpx`);

      const event: ActivityEvent = {
        type: 'activity',
        unique_hash: `activity:garmin:${activity.activityId}`,
        time: {
          start: new Date(activity.startTimeGMT).getTime(),
          end: new Date(endTimeGMT).getTime()
        },
        source: 'garmin',
        preview_url: `https://connect.garmin.com/app/activity/${activity.activityId}`,
        payload: {
          activity_id: activity.activityId.toString(),
          sport: activity.activityType.typeKey,
          distance: activity.distance,
          duration: activity.duration,
          gpx: gpx.toString(),
        }
      };

      events.push(event);

      await delay(2000);
    }

    let continuation: SyncResult<State>['continuation'] = undefined;

    if ((ctx.trigger === 'sync_all' && dailySyncContinuation) || (ctx.trigger === 'sync_all' && activities.length === activitiesCount)) {
      continuation = {
        state: {
          ...ctx.state,
          session: GCClient.exportToken(),
          cursor: start + activitiesCount,
        },
        schedule: {
          delayMs: 2 * 60 * 1000
        }
      }
    }

    return { events: await Promise.all(events), continuation };
};
