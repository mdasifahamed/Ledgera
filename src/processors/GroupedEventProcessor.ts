import { Worker, Job } from "bullmq";
import { redisConnection, QUEUE_NAMES } from "../config/redis";
import { GroupedEventJobData, GroupedTransaction } from "./queues";
import { EventDecoder, DecodedEventResult, RawEvent } from "../eventDeoder/EventDecoder";
import { DecodedEventStorage } from "../storage/DecodedEventStorage";



/**
 * This worker class consued data from the EventProcessord work where the events are 
 * groped into sing and multi and here those events are beind decoded and filany store into the db for the further processing
 */
export class GroupedEventProcessor {
  private worker: Worker<GroupedEventJobData>;
  private eventDecoder: EventDecoder;
  private decodedEventStorage = new DecodedEventStorage(); // class for the storing decoded event to the db

  constructor() {
    this.eventDecoder = new EventDecoder(); // event decoder class that decode the events to for fur ther calulatios 
    this.worker = new Worker<GroupedEventJobData>(
      QUEUE_NAMES.GROUPED_EVENTS,
      async (job: Job<GroupedEventJobData>) => {
        await this.process(job.data);
      },
      {
        connection: redisConnection,
        concurrency: 5,
      }
    );

    this.worker.on("completed", (job) => {
      console.log(
        `[GroupedEventProcessor] Batch ${job.data.fromBlock}-${job.data.toBlock} processed`
      );
    });

    this.worker.on("failed", (job, err) => {
      console.error(`[GroupedEventProcessor] Batch failed:`, err.message);
    });
  }

  /**
   * Process of the transation group evnet peocessing
   * @param data   gropued evnet data
   */
  private async process(data: GroupedEventJobData): Promise<void> {
    const { chainId, fromBlock, toBlock, single, multi } = data;

    console.log(
      `[GroupedEventProcessor] Chain ${chainId} Blocks ${fromBlock}-${toBlock}`
    );

    // Proceed and save the events
    Promise.all([
      await this.processSingleEventTransactions(single, chainId),
      await this.processMultiEventTransactions(multi, chainId)
    ])
  }

  /**
   * This function processes single event that means the transaction that only have the single event tranfers 
   * @param transactions single event transactions
   * @param chainId network id
   */
  private async processSingleEventTransactions(
    transactions: GroupedTransaction[],
    chainId: number
  ): Promise<void> {
    const allDecodedEvents: DecodedEventResult[] = [];

    for (const tx of transactions) {
      const rawEvents: RawEvent[] = tx.events.map((e) => ({
        address: e.address,
        blockNumber: tx.blockNumber,
        data: e.data,
        topics: e.topics,
        transactionHash: tx.transactionHash,
        transactionIndex: tx.transactionIndex,
      }));

      const decoded = this.eventDecoder.decodeEvents(
        rawEvents,
        chainId,
        tx.blockTimestamp
      );
      allDecodedEvents.push(...decoded);
    }

    // batch insert to db the decode events
    if (allDecodedEvents.length > 0) {
      await this.decodedEventStorage.insertBatch(
        allDecodedEvents.map((e) => ({
          chainId: e.chainId,
          blockNumber: BigInt(e.blockNumber),
          blockTimeStamp: new Date(e.blockTimeStamp * 1000),
          contractAddress: e.contractAddress,
          transactionHash: e.transactionHash,
          transactionIndex: e.transactionIndex,
          eventName: e.eventName,
          eventArgs: JSON.parse(e.eventArg),
        }))
      );
    }
    console.log(`[Single] Decoded ${allDecodedEvents.length} events`);
  }


  /**
   * Process multiple events from transaction
   * @param transactions 
   * @param chainId 
   */
  private async processMultiEventTransactions(
    transactions: GroupedTransaction[],
    chainId: number
  ): Promise<void> {
    const allDecodedEvents: DecodedEventResult[] = [];

    for (const tx of transactions) {
      const rawEvents: RawEvent[] = tx.events.map((e) => ({
        address: e.address,
        blockNumber: tx.blockNumber,
        data: e.data,
        topics: e.topics,
        transactionHash: tx.transactionHash,
        transactionIndex: tx.transactionIndex,
      }));

      const decoded = this.eventDecoder.decodeEvents(
        rawEvents,
        chainId,
        tx.blockTimestamp
      );
      allDecodedEvents.push(...decoded);
    }

    // Batch insert to the db decoded events 
    if (allDecodedEvents.length > 0) {
      await this.decodedEventStorage.insertBatch(
        allDecodedEvents.map((e) => ({
          chainId: e.chainId,
          blockNumber: BigInt(e.blockNumber),
          blockTimeStamp: new Date(e.blockTimeStamp * 1000),
          contractAddress: e.contractAddress,
          transactionHash: e.transactionHash,
          transactionIndex: e.transactionIndex,
          eventName: e.eventName,
          eventArgs: JSON.parse(e.eventArg),
        }))
      );
    }
    console.log(`[Multi] Decoded ${allDecodedEvents.length} events`);
  }

  async close(): Promise<void> {
    await this.worker.close();
  }
}
