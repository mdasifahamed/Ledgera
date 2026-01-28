import { Redis } from "ioredis";

/**
 * Creates redis connecstion to use bullMQ dor the worker queues
 */

export const redisConnection = new Redis({
  host: process.env.REDIS_HOST || "localhost",
  port: parseInt(process.env.REDIS_PORT || "6379"),
  maxRetriesPerRequest: null, // to run bullmq it is required here to keeep it null
});


/**
 * Names ofthe queues is being used
 */
export const QUEUE_NAMES = {
  BLOCKS: "block-processing",
  EVENTS: "event-processing",
  GROUPED_EVENTS: "grouped-event-processing",
} as const;
