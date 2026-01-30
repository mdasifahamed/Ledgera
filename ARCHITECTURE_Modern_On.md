# Blockchain Data Fetcher - Technical Architecture

A production-grade blockchain data fetching system using TypeScript, ethers.js v6, and BullMQ for parallel block and event processing across multiple chains with Prisma ORM and TimescaleDB for time-series storage.

---

## Table of Contents

1. [Project Structure](#1-project-structure)
2. [Data Flow Overview](#2-data-flow-overview)
3. [Configuration Layer](#3-configuration-layer)
4. [Core Modules](#4-core-modules)
5. [Worker Architecture](#5-worker-architecture)
6. [Processor Architecture](#6-processor-architecture)
7. [Event Decoding Layer](#7-event-decoding-layer)
8. [Database Layer](#8-database-layer)
   - 8.1 Prisma Schema
   - 8.2 TimescaleDB Setup
   - 8.3 Storage Layer
9. [Entry Points](#9-entry-points)
10. [Key Design Patterns](#10-key-design-patterns)
11. [Usage Examples](#11-usage-examples)

---

## 1. Project Structure

```
src/
├── config/                    # Configuration files
│   ├── chains.ts             # Chain RPC endpoints and settings
│   ├── redis.ts              # Redis connection and queue names
│   ├── cexAddress.ts         # CEX wallet addresses for tracking
│   └── eventAttributes.json  # Event signature to ABI mappings
├── core/                      # Core data fetching modules
│   ├── RpcManager.ts         # RPC endpoint management with failover
│   ├── BlockFetcher.ts       # Block data retrieval
│   └── EventFetcher.ts       # Event/log data retrieval
├── eventDeoder/               # Event decoding module
│   └── EventDecoder.ts       # Decodes raw events using ABI
├── workers/                   # Chain-specific workers
│   ├── BaseChainWorker.ts    # Abstract base with dual-phase logic
│   ├── EthereumWorker.ts     # Ethereum implementation
│   ├── PolygonWorker.ts      # Polygon implementation
│   └── BnbWorker.ts          # BNB Chain implementation
├── processors/                # Data processing and queuing
│   ├── queues.ts             # BullMQ queue definitions
│   ├── TransactionProcessor.ts    # Block/transaction + CEX flow processor → DB
│   ├── EventProcessor.ts          # Event grouping bridge (EVENTS → GROUPED_EVENTS)
│   ├── GroupedEventProcessor.ts   # Grouped event decoder processor → DB
│   └── index.ts              # Processor exports
├── storage/                   # Database storage layer
│   ├── DatabaseClient.ts     # Prisma singleton client
│   ├── NativeTransferStorage.ts   # Native transfer operations
│   ├── CexFlowStorage.ts          # CEX flow operations
│   ├── DecodedEventStorage.ts     # Decoded event operations
│   ├── StablecoinTransferStorage.ts   # Stablecoin transfer operations
│   ├── StablecoinCexFlowStorage.ts    # Stablecoin CEX flow operations
│   ├── PoolSwapStorage.ts    # Pool swap operations
│   ├── PoolLiquidityStorage.ts   # Pool liquidity operations
│   ├── PoolFeesStorage.ts    # Pool fees operations
│   └── index.ts              # Storage exports
├── generated/                 # Auto-generated code
│   └── prisma/               # Prisma client (generated)
├── index.ts                   # Main entry point (workers)
└── startProcessors.ts         # Processor startup script

prisma/                        # Database schema and migrations
├── schema.prisma             # Prisma ORM schema (PostgreSQL + TimescaleDB)
├── seed.ts                   # Database seeding script (chain_config)
└── timescaledb_setup.sql     # Hypertable initialization script
```

---

## 2. Data Flow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         index.ts                                 │
│              Parses CLI args, creates workers                    │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                    BaseChainWorker.start()                       │
│         Promise.all([runEventPhase(), runBlockPhase()])          │
└────────────┬─────────────────────────────────┬───────────────────┘
             │                                 │
             ▼                                 ▼
┌────────────────────────┐       ┌─────────────────────────────────┐
│     Event Phase        │       │        Block Phase              │
│  (Runs Concurrently)   │       │     (Runs Concurrently)         │
├────────────────────────┤       ├─────────────────────────────────┤
│ EventFetcher           │       │ BlockFetcher                    │
│ .fetchLogsWithFilter() │       │ .fetchBlock()                   │
│                        │       │                                 │
│ Batches of N blocks    │       │ One block at a time             │
│ Filtered by addresses  │       │ Full transaction data           │
└────────────┬───────────┘       └──────────────┬──────────────────┘
             │                                  │
             ▼                                  ▼
┌────────────────────────┐       ┌─────────────────────────────────┐
│ onEventsProcessed()    │       │ onBlockProcessed()              │
│ - Fetch block timestamps│       │ - Add to blockQueue             │
│ - Add to eventQueue    │       │                                 │
└────────────┬───────────┘       └──────────────┬──────────────────┘
             │                                  │
             └──────────────┬───────────────────┘
                            ▼
┌───────────────────────────────────────────────────────────────────┐
│                     Redis (BullMQ Queues)                         │
│  ┌─────────────────┐  ┌────────────────┐  ┌────────────────────┐  │
│  │ blockQueue      │  │ eventQueue     │  │ groupedEventQueue  │  │
│  │ "block-         │  │ "event-        │  │ "grouped-event-    │  │
│  │  processing"    │  │  processing"   │  │  processing"       │  │
│  │ 5 retries       │  │ 3 retries      │  │ 3 retries          │  │
│  └────────┬────────┘  └───────┬────────┘  └─────────┬──────────┘  │
└───────────┼───────────────────┼─────────────────────┼─────────────┘
            │                   │                     │
            ▼                   ▼                     ▼
┌───────────────────────┐ ┌───────────────────┐ ┌────────────────────────┐
│ TransactionProcessor  │ │ EventProcessor    │ │ GroupedEventProcessor  │
│ - Finds native ETH    │ │ - Groups logs by  │ │ - Uses EventDecoder    │
│   transfers           │ │   transaction     │ │ - Decodes single/multi │
│ - Calculates CEX      │ │ - Separates into  │ │   event transactions   │
│   inflow/outflow      │ │   single/multi    │ │ - Saves decoded events │
│ - Saves to DB         │ │ - Pushes to       │ │   to database          │
│   (native_transfers,  │ │   groupedEvent    │ │   (decoded_events)     │
│    cex_flows)         │ │   Queue           │ │                        │
└───────────┬───────────┘ └─────────┬─────────┘ └────────────┬───────────┘
            │                       │                        │
            │                       └────────────────────────┘
            └───────────────────────────────┬────────────────┘
                                            ▼
┌───────────────────────────────────────────────────────────────────┐
│              PostgreSQL + TimescaleDB (Prisma ORM)                │
│                                                                   │
│  Reference Tables:                                                │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐                  │
│  │ chain_config│ │ tokens      │ │ pools       │                  │
│  └─────────────┘ └─────────────┘ └─────────────┘                  │
│                                                                   │
│  Native Hypertables:                                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐                  │
│  │ native_     │ │ cex_flows   │ │ decoded_    │                  │
│  │ transfers   │ │             │ │ events      │                  │
│  └─────────────┘ └─────────────┘ └─────────────┘                  │
│                                                                   │
│  Stablecoin Hypertables:                                          │
│  ┌─────────────┐ ┌─────────────┐                                  │
│  │ stablecoin_ │ │ stablecoin_ │                                  │
│  │ transfers   │ │ cex_flows   │                                  │
│  └─────────────┘ └─────────────┘                                  │
│                                                                   │
│  Pool Metrics Hypertables:                                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐                  │
│  │ pool_swaps  │ │ pool_       │ │ pool_fees   │                  │
│  │             │ │ liquidity   │ │             │                  │
│  └─────────────┘ └─────────────┘ └─────────────┘                  │
└───────────────────────────────────────────────────────────────────┘
```

---

## 3. Configuration Layer

### 3.1 chains.ts - Chain Configuration

Defines all supported blockchains with their settings.

```typescript
interface ChainConfig {
  id: number; // Chain ID (1=ETH, 137=Polygon, 56=BNB)
  name: string; // Display name
  rpcEndpoints: string[]; // Fallback RPC providers
  blockTime: number; // Delay between block fetches (ms)
  blockThresholdForTheEvents: number; // Batch size for event fetching
  targetAddresses: string[]; // Contract addresses to filter events
}
```

**Supported Chains:**
| Chain | ID | Block Threshold | Target Addresses | CEX Tracking |
|----------|-----|-----------------|--------------------------|--------------|
| Ethereum | 1 | 500 blocks | USDT, Binance Hot Wallet | ✓ Full |
| Polygon | 137 | 500 blocks | Configurable | Placeholder |
| BNB | 56 | 500 blocks | Configurable | Placeholder |

**Why it exists:** Centralizes chain-specific settings. RPC endpoints have fallbacks for reliability. Block threshold respects RPC provider limits (many limit eth_getLogs to ~500-1000 blocks). CEX address sets are managed per-chain in `cexAddress.ts`.

---

### 3.2 redis.ts - Redis & Queue Configuration

```typescript
// Connection (configurable via env vars)
const redisConnection = new Redis({
  host: process.env.REDIS_HOST || "localhost",
  port: parseInt(process.env.REDIS_PORT || "6379"),
  maxRetriesPerRequest: null, // Required for BullMQ
});

// Queue names
const QUEUE_NAMES = {
  BLOCKS: "block-processing",
  EVENTS: "event-processing",
  GROUPED_EVENTS: "grouped-event-processing", // NEW: For decoded events
} as const;
```

**Why it exists:** BullMQ requires Redis for distributed job queuing. Separating queue names allows independent scaling of block vs event processing.

---

### 3.3 cexAddress.ts - Multi-Chain CEX Wallet Registry

```typescript
// Types
type CEXName = "binance" | "kucoin" | "bybit";
type ChainId = 1 | 56;  // 1 = Ethereum, 56 = BSC

// Structure (organized by CEX → chainId → addresses)
interface CEXAddressConfig {
  [cexName: string]: {
    [chainId: number]: string[];
  };
}

const cexAddresses: CEXAddressConfig = {
  binance: {
    1: ["0x...", ...],   // Ethereum - 30+ addresses
    56: [],              // BSC - placeholder
  },
  kucoin: {
    1: ["0x...", ...],   // Ethereum - 38+ addresses
    56: [],
  },
  bybit: {
    1: ["0x...", ...],   // Ethereum - 100+ addresses
    56: [],
  },
};

// Chain-aware utilities (preferred)
getCEXAddressSet(cexName, chainId): Set<string>           // Single CEX for chain
getCEXAddressSetsForChain(chainId): Map<CEXName, Set<string>>  // All CEX sets for chain
getAllCEXAddressesForChain(chainId): Set<string>          // All CEX addresses for chain

// Legacy utilities (deprecated - default to Ethereum)
getCEXAddressSets(): Map<string, Set<string>>  // @deprecated
getAllCEXAddresses(): Set<string>              // @deprecated
```

**Why it exists:** Tracks known exchange wallets to identify fund flows (deposits/withdrawals) in TransactionProcessor. Multi-chain support allows tracking CEX activity across different networks.

---

### 3.4 eventAttributes.json - Event Signature Mappings

A JSON configuration file mapping event topic signatures to their ABI definitions.

```json
{
  "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef": {
    "abi": [
      "event Transfer(address indexed from, address indexed to, uint256 value)"
    ]
  },
  "0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925": {
    "abi": [
      "event Approval(address indexed owner, address indexed spender, uint256 value)"
    ]
  },
  "0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822": {
    "abi": [
      "event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to)"
    ]
  }
  // 50+ event signatures supported
}
```

**Supported Events:** Transfer, Approval, Deposit, Withdrawal, Mint, Burn, Swap, Sync, Initialize, PoolCreated, and many more DeFi-related events.

**Why it exists:** Enables dynamic event decoding without hardcoding ABIs. The EventDecoder loads this at startup to parse raw log data into structured event arguments.

---

## 4. Core Modules

### 4.1 RpcManager.ts - RPC Failover & Load Balancing

**Purpose:** Manages multiple RPC endpoints with intelligent failover.

```typescript
class RpcManager {
  private providers: JsonRpcProvider[];
  private currentIndex = 0;
  private failedAttempts: Map<number, number>;

  async execute<T>(method: string, params: unknown[]): Promise<T> {
    // Try each provider, rotate on failure
    // Detect rate limits (HTTP 429)
    // Sleep 10s for rate limit, 5s for other errors
  }
}
```

**Key Features:**

- **Endpoint Rotation:** Cycles through providers on failure
- **Rate Limit Detection:** Detects HTTP 429 and waits 10 seconds
- **Retry Logic:** Tries all providers before failing

**Why it exists:** Public RPC endpoints are unreliable. Having multiple with automatic failover ensures continuous operation.

---

### 4.2 BlockFetcher.ts - Block Data Retrieval

**Purpose:** Fetches complete block data with all transactions.

```typescript
interface TransactionData {
  hash: string;
  from: string;
  to: string | null;
  value: string; // BigInt string (converted from hex)
  gasPrice: string | null; // Legacy
  maxFeePerGas: string | null; // EIP-1559
  maxPriorityFeePerGas: string | null;
  gas: string;
  nonce: string;
  input: string; // Call data (0x for native transfers)
  transactionIndex: number;
}

interface BlockData {
  number: number;
  hash: string;
  parentHash: string;
  timestamp: number; // Unix epoch (seconds)
  gasUsed: string; // Hex
  gasLimit: string; // Hex
  baseFeePerGas: string | null; // EIP-1559
  transactions: TransactionData[];
  transactionCount: number;
}
```

**RPC Call:** `eth_getBlockByNumber` with `true` flag for full tx objects.

**Why it exists:** Provides parsed, normalized block data. Converts hex values to BigInt strings for easier processing.

---

### 4.3 EventFetcher.ts - Event/Log Data Retrieval

**Purpose:** Fetches smart contract events within block ranges.

```typescript
interface LogData {
  address: string; // Contract that emitted the event
  topics: string[]; // Event signature + indexed params
  data: string; // Encoded non-indexed params
  blockNumber: number;
  blockHash: string;
  transactionHash: string;
  transactionIndex: number;
  logIndex: number; // Position within the block
  removed: boolean; // True if reorged out
}
```

**Methods:**

```typescript
// All logs in range
fetchLogs(startBlock, endBlock): Promise<LogData[]>

// Filtered by contract addresses
fetchLogsWithFilter(startBlock, endBlock, addresses?): Promise<LogData[]>
```

**RPC Call:** `eth_getLogs` with fromBlock, toBlock, optional address filter.

**Why it exists:** Events are how smart contracts communicate state changes. Filtering by address reduces noise and respects RPC limits.

---

## 5. Worker Architecture

### 5.1 BaseChainWorker.ts - Abstract Dual-Phase Worker

**Purpose:** Core fetching logic with parallel block + event phases.

```typescript
abstract class BaseChainWorker {
  protected rpc: RpcManager;
  protected blockFetcher: BlockFetcher;
  protected eventFetcher: EventFetcher;

  // Independent progress tracking
  protected eventBlock = 0; // Event phase progress
  protected blockBlock = 0; // Block phase progress
  protected targetBlock = 0; // Target to reach

  async start(fromBlock?: number): Promise<void> {
    // Run both phases concurrently
    await Promise.all([this.runEventPhase(), this.runBlockPhase()]);
  }
}
```

**Dual-Phase Design:**

| Event Phase                                   | Block Phase                |
| --------------------------------------------- | -------------------------- |
| Fetches logs in batches                       | Fetches blocks one-by-one  |
| `blockThresholdForTheEvents` blocks at a time | Respects `blockTime` delay |
| Filtered by `targetAddresses`                 | Full transaction data      |
| Calls `onEventsProcessed()`                   | Calls `onBlockProcessed()` |

**Hooks (implemented by subclasses):**

```typescript
// Custom logging per chain
abstract logBlock(block: BlockData, fetchTimeMs: number): void;
abstract logEventBatch(fromBlock, toBlock, logs, fetchTimeMs): void;

// Queue integration
protected async onBlockProcessed(block: BlockData): Promise<void> {
  await blockQueue.add(`block-${block.number}`, {
    chainId: this.config.id,
    block,
  });
}

protected async onEventsProcessed(logs: LogData[]): Promise<void> {
  // Get unique block numbers from logs
  const uniqueBlocks = [...new Set(logs.map(log => log.blockNumber))];

  // Fetch timestamps for each unique block
  const blockTimestamps: Record<number, number> = {};
  for (const blockNum of uniqueBlocks) {
    const block = await this.blockFetcher.fetchBlock(blockNum);
    blockTimestamps[blockNum] = block.timestamp;
  }

  // Push to eventQueue (EventProcessor will group and forward)
  await eventQueue.add(`events-${this.eventBlock}`, {
    chainId: this.config.id,
    fromBlock: this.eventBlock,
    toBlock: Math.min(this.eventBlock + this.config.blockThresholdForTheEvents - 1, this.targetBlock),
    logs,
    blockTimestamps,
  });
}
```

**Why dual-phase:** Events and blocks are independent data sources. Fetching them in parallel maximizes throughput. If one phase fails, the other continues.

---

### 5.2 Chain-Specific Workers

All extend `BaseChainWorker` and only override logging methods.

```typescript
// EthereumWorker.ts
class EthereumWorker extends BaseChainWorker {
  constructor(targetBlock: number) {
    super(getChainConfig("ethereum"), targetBlock);
  }

  protected logBlock(block: BlockData, fetchTimeMs: number): void {
    console.log(`[ETH] Block #${block.number}`);
    console.log(`  Hash: ${block.hash}`);
    console.log(`  Time: ${new Date(block.timestamp * 1000).toISOString()}`);
    // ... gas, base fee, etc.
  }
}
```

**Why separate classes:** Each chain may have unique logging needs or future chain-specific logic. Keeps code organized.

---

## 6. Processor Architecture

### 6.1 queues.ts - BullMQ Queue Definitions

```typescript
// Block job data
interface BlockJobData {
  chainId: number;
  block: BlockData;
}

// Event job data (raw logs)
interface EventJobData {
  chainId: number;
  fromBlock: number;
  toBlock: number;
  logs: LogData[];
  blockTimestamps: Record<number, number>; // blockNumber -> timestamp
}

// Event data extracted from log
interface EventData {
  logIndex: number;
  topics: string[];
  data: string;
  address: string;
}

// Transaction with grouped events
interface GroupedTransaction {
  blockHash: string;
  blockNumber: number;
  blockTimestamp: number;
  removed: boolean;
  transactionHash: string;
  transactionIndex: number;
  events: EventData[];
}

// Grouped event job data (for decoding)
interface GroupedEventJobData {
  chainId: number;
  fromBlock: number;
  toBlock: number;
  single: GroupedTransaction[]; // Transactions with 1 event
  multi: GroupedTransaction[]; // Transactions with multiple events
}

// Queue configurations
const blockQueue = new Queue<BlockJobData>(QUEUE_NAMES.BLOCKS, {
  connection: redisConnection,
  defaultJobOptions: {
    attempts: 5, // Retry 5 times
    backoff: { type: "exponential", delay: 10000 },
    removeOnComplete: 100, // Keep last 100
    removeOnFail: 1000, // Keep last 1000 failed
  },
});

const eventQueue = new Queue<EventJobData>(QUEUE_NAMES.EVENTS, {
  // Similar config, 3 attempts
});

const groupedEventQueue = new Queue<GroupedEventJobData>(
  QUEUE_NAMES.GROUPED_EVENTS,
  {
    // Similar config, 3 attempts
  },
);
```

**Why BullMQ:** Distributed job processing with automatic retries, failure tracking, and persistence.

---

### 6.2 TransactionProcessor.ts - Native Transfer & CEX Flow Analysis

**Purpose:** Analyzes native ETH/BNB/MATIC transfers to track exchange fund flows with multi-chain support. **Saves data to `native_transfers` and `cex_flows` tables.**

```typescript
interface NativeTransfer {
  from: string;
  to: string;
  value: string;
  blockTimeStamp: number;
  transactionHash: string;
  transactionIndex: number;
}

interface BlockNativeTransfer {
  nativeTransfers: NativeTransfer[];
  blockNumber: bigint;
  blockHash: string;
  blockParentHash: string;
  timeStamp: number;
  totalAmount: string;
  chainId: number;
}

// Self-contained flow record (each record = one CEX + one flow direction)
interface CEXFlowRecord {
  transactionHashes: string[];
  flowType: "inflow" | "outflow";
  totalAmount: string; // in wei
  totalAmountEth: string; // in ETH (human readable)
  cexName: string; // e.g., "binance", "kucoin", "bybit"
  chainId: number; // e.g., 1 (ETH), 56 (BSC)
  blockNumber: number;
  blockTimeStamp: number;
}

// Block-level result with flat list of flows
interface BlockCEXFlowResult {
  flows: CEXFlowRecord[]; // Flat list of per-CEX, per-direction flows
  // Block-level totals (ALL CEX combined)
  totalInflowInSmallest: string; // Total inflow in wei
  totalInflowHumanNumber: string; // Total inflow in ETH
  totalInflowCount: number;
  totalOutflowInSmallest: string; // Total outflow in wei
  totalOutflowHumnaNumber: string; // Total outflow in ETH
  totalOutflowCount: number;
  // Block metadata
  blockNumber: number;
  blockTimeStamp: number;
  blockHash: string;
  parentBlockHash: string;
  chainId: number;
}

// Internal helper type for flow calculation
interface FlowCalcResult {
  transactionHashes: string[];
  totalInSmallestNumber: string; // wei
  totalInHumanNumber: string; // ETH
  count: number;
}
```

**Key Methods:**

```typescript
// Main processing entry point
private async process(data: BlockJobData): Promise<void>

// CEX flow calculation (uses chain-aware CEX lookups)
private async calculateBlockCEXFlows(data: BlockJobData): Promise<BlockCEXFlowResult>

// Helper: calculates flows for a specific CEX and direction
private calculateFlowForCEX(
  nativeTransfers: TransactionData[],
  cexAddressSet: Set<string>,
  allCEXAddresses: Set<string>,
  flowType: "inflow" | "outflow"
): FlowCalcResult

// Helper: extracts native transfers from block
private async findNativeTransfer(data: BlockJobData): Promise<BlockNativeTransfer>
```

**Flow Detection Logic:**

```typescript
// Uses chain-aware CEX lookups
const cexAddressSets = getCEXAddressSetsForChain(chainId);
const allCEXAddresses = getAllCEXAddressesForChain(chainId);

// Inflow (deposit): to=THIS CEX && from≠ANY CEX
const isInflow = isToThisCex && !isFromAnyCex;

// Outflow (withdrawal): from=THIS CEX && to≠ANY CEX
const isOutflow = isFromThisCex && !isToAnyCex;
```

**Native Transfer Filter:**

```typescript
const nativeTransfers = block.transactions.filter(
  (tx) =>
    tx.input === "0x" && // No contract call
    tx.value !== "0" && // Has value
    tx.to !== null, // Not contract creation
);
```

---

### 6.3 EventProcessor.ts - Event Grouping Bridge

**Purpose:** Bridges the `EVENTS` queue to `GROUPED_EVENTS` queue by grouping raw logs by transaction and separating them into single/multi-event transactions.

```typescript
class EventProcessor {
  private worker: Worker<EventJobData>;

  constructor() {
    this.worker = new Worker<EventJobData>(
      QUEUE_NAMES.EVENTS,
      async (job) => await this.process(job.data),
      { connection: redisConnection, concurrency: 5 },
    );
  }

  private async process(data: EventJobData): Promise<void> {
    const { chainId, fromBlock, toBlock, logs, blockTimestamps } = data;

    // Group logs by transaction hash
    const txMap = new Map<string, GroupedTransaction>();

    for (const log of logs) {
      const txHash = log.transactionHash;

      if (!txMap.has(txHash)) {
        txMap.set(txHash, {
          blockHash: log.blockHash,
          blockNumber: log.blockNumber,
          blockTimestamp: blockTimestamps[log.blockNumber] || 0,
          removed: log.removed,
          transactionHash: txHash,
          transactionIndex: log.transactionIndex,
          events: [],
        });
      }

      txMap.get(txHash)!.events.push({
        logIndex: log.logIndex,
        topics: log.topics,
        data: log.data,
        address: log.address,
      });
    }

    // Separate into single and multi-event transactions
    const single: GroupedTransaction[] = [];
    const multi: GroupedTransaction[] = [];

    for (const tx of txMap.values()) {
      if (tx.events.length === 1) {
        single.push(tx);
      } else {
        multi.push(tx);
      }
    }

    // Push to grouped event queue for decoding
    if (single.length > 0 || multi.length > 0) {
      await groupedEventQueue.add(`grouped-${fromBlock}-${toBlock}`, {
        chainId,
        fromBlock,
        toBlock,
        single,
        multi,
      });
    }
  }
}
```

**Why this exists:** The worker's `onEventsProcessed()` pushes raw logs to the `EVENTS` queue. This processor bridges to `GROUPED_EVENTS` queue by:

1. Grouping logs by transaction hash
2. Attaching block timestamps to each transaction
3. Separating transactions into single-event (simple transfers) vs multi-event (complex operations)

---

### 6.4 GroupedEventProcessor.ts - Event Decoding Processor

**Purpose:** Processes grouped events from BullMQ queue and decodes them using EventDecoder. **Saves decoded events to `decoded_events` table.**

```typescript
class GroupedEventProcessor {
  private worker: Worker<GroupedEventJobData>;
  private eventDecoder: EventDecoder;
  private decodedEventStorage = new DecodedEventStorage();

  constructor() {
    this.eventDecoder = new EventDecoder();
    this.worker = new Worker<GroupedEventJobData>(
      QUEUE_NAMES.GROUPED_EVENTS,
      async (job) => await this.process(job.data),
      { connection: redisConnection, concurrency: 5 },
    );
  }

  private async process(data: GroupedEventJobData): Promise<void> {
    const { chainId, fromBlock, toBlock, single, multi } = data;

    // Process single-event transactions
    await this.processSingleEventTransactions(single, chainId);

    // Process multi-event transactions
    await this.processMultiEventTransactions(multi, chainId);
  }

  private async processSingleEventTransactions(
    transactions: GroupedTransaction[],
    chainId: number,
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
        tx.blockTimestamp,
      );
      allDecodedEvents.push(...decoded);
    }

    // Save decoded events to database
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
        })),
      );
    }
  }
}
```

**Why separate single/multi:** Single-event transactions are often simple transfers. Multi-event transactions indicate complex operations (swaps, flash loans, etc.). Both are decoded and saved to the `decoded_events` table.

---

## 7. Event Decoding Layer

### 7.1 EventDecoder.ts - ABI-Based Event Decoding

**Purpose:** Decodes raw blockchain events using ethers.js Interface parsing.

```typescript
interface DecodedEventResult {
  contractAddress: string;
  chainId: number;
  blockNumber: number;
  blockTimeStamp: number;
  transactionHash: string;
  transactionIndex: number;
  eventName: string; // "Transfer", "Swap", "Approval", etc.
  eventArg: string; // JSON serialized event arguments
}

interface RawEvent {
  address: string;
  blockNumber: number;
  data: string;
  topics: string[];
  transactionHash: string;
  transactionIndex: number;
}

class EventDecoder {
  private interfaces: Map<
    string,
    { iface: ethers.Interface; eventName: string }
  >;

  constructor() {
    this.interfaces = new Map();
    this.loadEventConfigs(); // Loads from eventAttributes.json
  }

  private loadEventConfigs(): void {
    const configPath = path.join(__dirname, "../config/eventAttributes.json");
    const eventAttributes = JSON.parse(fs.readFileSync(configPath, "utf-8"));

    for (const [signature, config] of Object.entries(eventAttributes)) {
      const iface = new ethers.Interface(config.abi);
      const fragment = iface.fragments[0] as ethers.EventFragment;
      this.interfaces.set(signature, { iface, eventName: fragment.name });
    }
  }

  decodeEvents(
    events: RawEvent[],
    chainId: number,
    blockTimeStamp: number,
  ): DecodedEventResult[] {
    const results: DecodedEventResult[] = [];

    for (const event of events) {
      const signature = event.topics[0];
      const config = this.interfaces.get(signature);
      if (!config) continue;

      const parsed = config.iface.parseLog({
        topics: event.topics,
        data: event.data,
      });

      if (parsed) {
        results.push({
          contractAddress: event.address,
          chainId,
          blockNumber: event.blockNumber,
          blockTimeStamp,
          transactionHash: event.transactionHash,
          transactionIndex: event.transactionIndex,
          eventName: parsed.name,
          eventArg: JSON.stringify(parsed.args.toObject(), (_, v) =>
            typeof v === "bigint" ? v.toString() : v,
          ),
        });
      }
    }

    return results;
  }
}
```

**Why it exists:** Transforms raw hex-encoded event data into human-readable structured data. Handles BigInt serialization and gracefully skips events that don't match known ABIs.

---

## 8. Database Layer

### 8.1 Prisma Schema (schema.prisma)

**Database:** PostgreSQL with TimescaleDB extension for time-series optimization.

```prisma
generator client {
  provider = "prisma-client-js"
  output   = "../src/generated/prisma"
}

datasource db {
  provider = "postgresql"
}

// Reference table for chain metadata
model ChainConfig {
  chainId     Int    @id
  networkName String
  tokenSymbol String

  // Relations
  nativeTransfers      NativeTransfer[]
  cexFlows             CexFlow[]
  decodedEvents        DecodedEvent[]
  tokens               Token[]
  pools                Pool[]
  stablecoinTransfers  StablecoinTransfer[]
  stablecoinCexFlows   StablecoinCexFlow[]
  poolSwaps            PoolSwap[]
  poolLiquidity        PoolLiquidity[]
  poolFees             PoolFees[]

  @@map("chain_config")
}

// Token metadata (ERC-20 tokens)
model Token {
  id           String @id @default(uuid())
  chainId      Int
  tokenAddress String
  tokenName    String
  tokenSymbol  String
  tokenDecimal Int

  chain ChainConfig @relation(fields: [chainId], references: [chainId])
  poolsAsToken0 Pool[] @relation("Token0")
  poolsAsToken1 Pool[] @relation("Token1")

  // Stablecoin metrics relations
  stablecoinTransfers StablecoinTransfer[]
  stablecoinCexFlows  StablecoinCexFlow[]

  @@unique([chainId, tokenAddress])
  @@index([tokenSymbol])
  @@map("tokens")
}

// DEX liquidity pool metadata
model Pool {
  id            String  @id @default(uuid())
  chainId       Int
  poolAddress   String
  token0Address String
  token1Address String
  poolSymbol    String  // e.g., "WETH/USDT"
  dexName       String  // e.g., "uniswap", "sushiswap"
  dexVersion    String? // e.g., "v2", "v3"
  fees          Int[]   // Array of fee tiers

  chain  ChainConfig @relation(fields: [chainId], references: [chainId])
  token0 Token @relation("Token0", fields: [chainId, token0Address], references: [chainId, tokenAddress])
  token1 Token @relation("Token1", fields: [chainId, token1Address], references: [chainId, tokenAddress])

  // Pool metrics relations
  swaps     PoolSwap[]
  liquidity PoolLiquidity[]
  poolFees  PoolFees[]

  @@unique([chainId, poolAddress])
  @@index([dexName])
  @@map("pools")
}

// Native transfers - HYPERTABLE (partitioned by blockTimeStamp)
model NativeTransfer {
  id                String   @id @default(uuid())
  chainId           Int
  blockNumber       BigInt
  blockHash         String
  blockTimeStamp    DateTime // TimescaleDB partition key
  totalAmount       String   // Wei as string
  transactionHashes String[]

  chain ChainConfig @relation(fields: [chainId], references: [chainId])

  @@index([chainId, blockTimeStamp])
  @@index([blockNumber])
  @@map("native_transfers")
}

// CEX inflow/outflow per block - HYPERTABLE
model CexFlow {
  id                String   @id @default(uuid())
  chainId           Int
  blockNumber       BigInt
  blockTimeStamp    DateTime // TimescaleDB partition key
  cexName           String   // "binance", "kucoin", "bybit"
  flowType          FlowType // INFLOW or OUTFLOW
  totalAmount       String   // Wei
  totalAmountHuman  String   // Human readable (ETH)
  transactionHashes String[]
  transactionCount  Int

  chain ChainConfig @relation(fields: [chainId], references: [chainId])

  @@index([chainId, blockTimeStamp])
  @@index([cexName, flowType])
  @@index([blockNumber])
  @@map("cex_flows")
}

enum FlowType {
  INFLOW
  OUTFLOW
}

enum LiquidityType {
  ADD    // Mint events - liquidity provision
  REMOVE // Burn events - liquidity withdrawal
}

// Decoded smart contract events - HYPERTABLE
model DecodedEvent {
  id               String   @id @default(uuid())
  chainId          Int
  blockNumber      BigInt
  blockTimeStamp   DateTime // TimescaleDB partition key
  contractAddress  String
  transactionHash  String
  transactionIndex Int
  eventName        String   // "Transfer", "Swap", etc.
  eventArgs        Json     // Decoded event arguments

  chain ChainConfig @relation(fields: [chainId], references: [chainId])

  @@index([chainId, blockTimeStamp])
  @@index([contractAddress])
  @@index([eventName])
  @@index([transactionHash])
  @@map("decoded_events")
}

// Stablecoin transfers per block - HYPERTABLE
model StablecoinTransfer {
  id                String   @id @default(uuid())
  chainId           Int
  tokenAddress      String   // Stablecoin contract address (lowercase)
  blockNumber       BigInt
  blockHash         String
  blockTimeStamp    DateTime // TimescaleDB partition key
  totalAmount       String   // Smallest unit as string
  totalAmountHuman  String   // Human readable
  transactionHashes String[]
  transactionCount  Int

  chain ChainConfig @relation(fields: [chainId], references: [chainId])
  token Token       @relation(fields: [chainId, tokenAddress], references: [chainId, tokenAddress])

  @@unique([chainId, tokenAddress, blockNumber])
  @@index([chainId, blockTimeStamp])
  @@index([chainId, tokenAddress])
  @@index([blockNumber])
  @@map("stablecoin_transfers")
}

// Stablecoin CEX flows per block - HYPERTABLE
model StablecoinCexFlow {
  id                String   @id @default(uuid())
  chainId           Int
  tokenAddress      String
  blockNumber       BigInt
  blockTimeStamp    DateTime // TimescaleDB partition key
  cexName           String   // "binance", "kucoin", "bybit"
  flowType          FlowType // INFLOW or OUTFLOW
  totalAmount       String
  totalAmountHuman  String
  transactionHashes String[]
  transactionCount  Int

  chain ChainConfig @relation(fields: [chainId], references: [chainId])
  token Token       @relation(fields: [chainId, tokenAddress], references: [chainId, tokenAddress])

  @@unique([chainId, tokenAddress, cexName, flowType, blockNumber])
  @@index([chainId, blockTimeStamp])
  @@index([chainId, cexName, flowType])
  @@index([chainId, tokenAddress, flowType])
  @@index([blockNumber])
  @@map("stablecoin_cex_flows")
}

// Pool swaps per block - HYPERTABLE
model PoolSwap {
  id                String   @id @default(uuid())
  chainId           Int
  poolAddress       String   // DEX pool address (lowercase)
  blockNumber       BigInt
  blockTimeStamp    DateTime // TimescaleDB partition key
  volumeToken0      String   // Amount of token0 swapped (smallest unit)
  volumeToken0Human String   // Human readable
  volumeToken1      String   // Amount of token1 swapped (smallest unit)
  volumeToken1Human String   // Human readable
  swapCount         Int      // Number of swaps in this block
  transactionHashes String[]

  chain ChainConfig @relation(fields: [chainId], references: [chainId])
  pool  Pool        @relation(fields: [chainId, poolAddress], references: [chainId, poolAddress])

  @@unique([chainId, poolAddress, blockNumber])
  @@index([chainId, blockTimeStamp])
  @@index([chainId, poolAddress])
  @@index([blockNumber])
  @@map("pool_swaps")
}

// Pool liquidity changes per block - HYPERTABLE
model PoolLiquidity {
  id                String        @id @default(uuid())
  chainId           Int
  poolAddress       String
  blockNumber       BigInt
  blockTimeStamp    DateTime      // TimescaleDB partition key
  liquidityType     LiquidityType // ADD (Mint) or REMOVE (Burn)
  amountToken0      String        // Token0 amount (smallest unit)
  amountToken0Human String        // Human readable
  amountToken1      String        // Token1 amount (smallest unit)
  amountToken1Human String        // Human readable
  transactionCount  Int
  transactionHashes String[]

  chain ChainConfig @relation(fields: [chainId], references: [chainId])
  pool  Pool        @relation(fields: [chainId, poolAddress], references: [chainId, poolAddress])

  @@unique([chainId, poolAddress, liquidityType, blockNumber])
  @@index([chainId, blockTimeStamp])
  @@index([chainId, poolAddress, liquidityType])
  @@index([blockNumber])
  @@map("pool_liquidity")
}

// Pool fees collected per block - HYPERTABLE
model PoolFees {
  id                String   @id @default(uuid())
  chainId           Int
  poolAddress       String
  blockNumber       BigInt
  blockTimeStamp    DateTime // TimescaleDB partition key
  feesToken0        String   // Token0 fees (smallest unit)
  feesToken0Human   String   // Human readable
  feesToken1        String   // Token1 fees (smallest unit)
  feesToken1Human   String   // Human readable
  collectCount      Int      // Number of Collect events
  transactionHashes String[]

  chain ChainConfig @relation(fields: [chainId], references: [chainId])
  pool  Pool        @relation(fields: [chainId, poolAddress], references: [chainId, poolAddress])

  @@unique([chainId, poolAddress, blockNumber])
  @@index([chainId, blockTimeStamp])
  @@index([chainId, poolAddress])
  @@index([blockNumber])
  @@map("pool_fees")
}
```

---

### 8.2 TimescaleDB Setup (timescaledb_setup.sql)

Run after `prisma migrate dev` to convert tables to hypertables:

```sql
-- Enable TimescaleDB extension
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Convert to hypertables (1 day chunks)
-- Native tables
SELECT create_hypertable('native_transfers', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);
SELECT create_hypertable('cex_flows', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);
SELECT create_hypertable('decoded_events', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);

-- Stablecoin tables
SELECT create_hypertable('stablecoin_transfers', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);
SELECT create_hypertable('stablecoin_cex_flows', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);

-- Pool metrics tables
SELECT create_hypertable('pool_swaps', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);
SELECT create_hypertable('pool_liquidity', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);
SELECT create_hypertable('pool_fees', 'blockTimeStamp',
  chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);

-- Enable compression (native tables)
ALTER TABLE native_transfers SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId'
);
ALTER TABLE cex_flows SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId,cexName'
);
ALTER TABLE decoded_events SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId,eventName'
);

-- Enable compression (stablecoin tables)
ALTER TABLE stablecoin_transfers SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId,tokenAddress'
);
ALTER TABLE stablecoin_cex_flows SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId,tokenAddress,cexName'
);

-- Enable compression (pool metrics tables)
ALTER TABLE pool_swaps SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId,poolAddress'
);
ALTER TABLE pool_liquidity SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId,poolAddress,liquidityType'
);
ALTER TABLE pool_fees SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'chainId,poolAddress'
);

-- Compression policy (compress data older than 7 days)
SELECT add_compression_policy('native_transfers', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_compression_policy('cex_flows', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_compression_policy('decoded_events', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_compression_policy('stablecoin_transfers', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_compression_policy('stablecoin_cex_flows', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_compression_policy('pool_swaps', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_compression_policy('pool_liquidity', INTERVAL '7 days', if_not_exists => TRUE);
SELECT add_compression_policy('pool_fees', INTERVAL '7 days', if_not_exists => TRUE);

-- Seed chain configurations
INSERT INTO chain_config ("chainId", "networkName", "tokenSymbol") VALUES
  (1, 'Ethereum', 'ETH'),
  (56, 'BNB Chain', 'BNB'),
  (137, 'Polygon', 'MATIC')
ON CONFLICT ("chainId") DO NOTHING;
```

**Why TimescaleDB:** Optimized for time-series data with automatic partitioning, compression, and efficient time-range queries essential for blockchain data analysis.

---

### 8.3 Storage Layer (src/storage/)

Repository classes providing typed insert operations with upsert handling for idempotency.

**DatabaseClient.ts - Prisma Singleton**

```typescript
import { PrismaClient } from "../generated/prisma";

class DatabaseClient {
  private static instance: PrismaClient;

  static getInstance(): PrismaClient {
    if (!DatabaseClient.instance) {
      DatabaseClient.instance = new PrismaClient();
    }
    return DatabaseClient.instance;
  }

  static async disconnect(): Promise<void> {
    if (DatabaseClient.instance) {
      await DatabaseClient.instance.$disconnect();
    }
  }
}

export const prisma = DatabaseClient.getInstance();
export { DatabaseClient };
```

**Storage Class Pattern (all storage classes follow this pattern):**

```typescript
import { prisma } from "./DatabaseClient";

export interface PoolSwapInput {
  chainId: number;
  poolAddress: string;
  blockNumber: bigint;
  blockTimeStamp: Date;
  volumeToken0: string;
  volumeToken0Human: string;
  volumeToken1: string;
  volumeToken1Human: string;
  swapCount: number;
  transactionHashes: string[];
}

export class PoolSwapStorage {
  // Single insert (upsert to handle duplicates)
  async insert(data: PoolSwapInput): Promise<void> {
    await prisma.poolSwap.upsert({
      where: {
        chainId_poolAddress_blockNumber: {
          chainId: data.chainId,
          poolAddress: data.poolAddress,
          blockNumber: data.blockNumber,
        },
      },
      update: { /* fields to update */ },
      create: data,
    });
  }

  // Batch insert (uses transaction for atomicity)
  async insertBatch(records: PoolSwapInput[]): Promise<void> {
    if (records.length === 0) return;
    const operations = records.map((data) => prisma.poolSwap.upsert({...}));
    await prisma.$transaction(operations);
  }
}
```

**Available Storage Classes:**

| Class                       | Table                | Unique Key                                                | Used By               |
| --------------------------- | -------------------- | --------------------------------------------------------- | --------------------- |
| `NativeTransferStorage`     | native_transfers     | chainId + blockNumber                                     | TransactionProcessor  |
| `CexFlowStorage`            | cex_flows            | chainId + cexName + flowType + blockNumber                | TransactionProcessor  |
| `DecodedEventStorage`       | decoded_events       | (auto-generated id)                                       | GroupedEventProcessor |
| `StablecoinTransferStorage` | stablecoin_transfers | chainId + tokenAddress + blockNumber                      | -                     |
| `StablecoinCexFlowStorage`  | stablecoin_cex_flows | chainId + tokenAddress + cexName + flowType + blockNumber | -                     |
| `PoolSwapStorage`           | pool_swaps           | chainId + poolAddress + blockNumber                       | -                     |
| `PoolLiquidityStorage`      | pool_liquidity       | chainId + poolAddress + liquidityType + blockNumber       | -                     |
| `PoolFeesStorage`           | pool_fees            | chainId + poolAddress + blockNumber                       | -                     |

**Usage:**

```typescript
import { PoolSwapStorage, StablecoinTransferStorage } from "./storage";

const swapStorage = new PoolSwapStorage();
const stablecoinStorage = new StablecoinTransferStorage();

// Single insert
await swapStorage.insert({
  chainId: 1,
  poolAddress: "0x...",
  blockNumber: 12345678n,
  blockTimeStamp: new Date(),
  volumeToken0: "1000000000000000000",
  volumeToken0Human: "1.0",
  volumeToken1: "2000000000",
  volumeToken1Human: "2000.0",
  swapCount: 5,
  transactionHashes: ["0x...", "0x..."],
});

// Batch insert
await swapStorage.insertBatch([record1, record2, record3]);
```

**Design Decisions:**
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Operation type | Upsert | Handles re-processing of same blocks gracefully |
| Batch strategy | `$transaction` with upserts | Atomicity + duplicate handling |
| Client management | Singleton pattern | Single connection pool, efficient resource use |
| Input types | Separate interfaces | Type safety, clear contracts |

---

## 9. Entry Points

### 9.1 index.ts - Worker Entry Point

```bash
# Usage
npx tsx src/index.ts --chain=ethereum --block=21890000 --targetBlock=21890010

# Arguments
--chain=<name>        # ethereum | polygon | bnb | all (default: ethereum)
--block=<number>      # Starting block (optional)
--targetBlock=<number> # Target block (required)
```

**Graceful Shutdown:**

- Handles SIGINT/SIGTERM
- Prints final progress of both phases
- Waits 1 second for cleanup

---

### 9.2 startProcessors.ts - Processor Entry Point

```bash
# Run in separate terminal
npx tsx src/startProcessors.ts
```

Initializes the following processors:

- `TransactionProcessor` - Processes blocks, extracts native transfers, calculates CEX flows → saves to `native_transfers` and `cex_flows` tables
- `EventProcessor` - Groups raw event logs by transaction, bridges `EVENTS` queue to `GROUPED_EVENTS` queue
- `GroupedEventProcessor` - Decodes grouped events using EventDecoder → saves to `decoded_events` table

**Graceful Shutdown:** Handles SIGINT/SIGTERM to cleanly close all processor workers.

---

### 9.3 prisma/seed.ts - Database Seeding

```bash
# Seed the chain_config table
npx tsx prisma/seed.ts
```

Seeds the `chain_config` reference table with common blockchain networks:

```typescript
const chainConfigs = [
  { chainId: 1, networkName: "Ethereum Mainnet", tokenSymbol: "ETH" },
  { chainId: 137, networkName: "Polygon", tokenSymbol: "MATIC" },
  { chainId: 42161, networkName: "Arbitrum One", tokenSymbol: "ETH" },
  { chainId: 10, networkName: "Optimism", tokenSymbol: "ETH" },
  { chainId: 8453, networkName: "Base", tokenSymbol: "ETH" },
  { chainId: 56, networkName: "BNB Smart Chain", tokenSymbol: "BNB" },
  { chainId: 43114, networkName: "Avalanche C-Chain", tokenSymbol: "AVAX" },
];
```

**Why this exists:** Foreign key constraints require `chain_config` entries to exist before inserting data into `native_transfers`, `cex_flows`, `decoded_events`, etc. Run this after migrations to populate the reference table.

---

## 10. Key Design Patterns

### 10.1 Dual-Phase Concurrent Architecture

```
┌─────────────────────────────────────────┐
│          BaseChainWorker.start()        │
│  Promise.all([eventPhase, blockPhase])  │
└──────────┬──────────────────┬───────────┘
           │                  │
    ┌──────▼──────┐    ┌──────▼──────┐
    │ Event Phase │    │ Block Phase │
    │ Progress: N │    │ Progress: M │
    └─────────────┘    └─────────────┘
```

- Independent progress tracking
- No blocking between phases
- Survives partial failures

### 10.2 RPC Failover

```
Provider 1 ──► Rate Limited ──► Rotate ──► Provider 2
                  │                           │
                  └── Wait 10s ───────────────┘
```

### 10.3 Queue-Based Processing Pipeline

```
                    ┌─────────────────────────────────────────────────────┐
                    │                    Redis Queues                      │
                    └─────────────────────────────────────────────────────┘
                                           │
        ┌──────────────────────────────────┼──────────────────────────────┐
        ▼                                  ▼                              ▼
┌───────────────┐                 ┌───────────────┐              ┌───────────────┐
│  blockQueue   │                 │  eventQueue   │              │groupedEvent   │
│  (BLOCKS)     │                 │  (EVENTS)     │              │Queue (GROUPED)│
└───────┬───────┘                 └───────┬───────┘              └───────┬───────┘
        │                                 │                              │
        ▼                                 ▼                              ▼
┌───────────────────┐           ┌─────────────────────┐       ┌────────────────────┐
│Transaction        │           │ EventProcessor      │       │GroupedEvent        │
│Processor          │           │ (Bridge)            │       │Processor           │
│                   │           │                     │       │                    │
│ Saves:            │           │ Groups by tx hash   │──────►│ Saves:             │
│ - native_transfers│           │ Pushes to GROUPED   │       │ - decoded_events   │
│ - cex_flows       │           └─────────────────────┘       └────────────────────┘
└───────────────────┘
```

- Decouples fetching from processing
- Allows independent scaling
- Built-in retry and failure tracking
- EventProcessor bridges EVENTS → GROUPED_EVENTS queues

### 10.4 Block Timestamp Propagation

```
Events don't have timestamps
         │
         ▼
onEventsProcessed() fetches unique block timestamps
         │
         ▼
EventJobData includes blockTimestamps map
         │
         ▼
EventProcessor attaches timestamp to each GroupedTransaction
         │
         ▼
GroupedEventProcessor uses timestamps when decoding/saving
```

### 10.5 Multi-Chain CEX Address Management

```
CEXAddressConfig (organized by CEX → chainId → addresses)
         │
         ▼
Chain-aware functions: getCEXAddressSetsForChain(chainId)
         │
         ▼
TransactionProcessor uses chainId from BlockJobData
         │
         ▼
Correct CEX addresses loaded per-chain for flow detection
```

### 10.6 Event Decoding Pipeline

```
Raw LogData (hex topics + data)
         │
         ▼
EventDecoder loads eventAttributes.json
         │
         ▼
ethers.Interface.parseLog() decodes each event
         │
         ▼
DecodedEventResult with eventName + eventArg (JSON)
         │
         ▼
Ready for database insertion (DecodedEvent model)
```

### 10.7 Storage Layer Pattern

```
Processor prepares data
         │
         ▼
Storage class receives typed input
         │
         ▼
Upsert operation (insert or update)
         │
         ├── Single: prisma.table.upsert()
         │
         └── Batch: prisma.$transaction([upserts...])
         │
         ▼
Idempotent: Safe to re-process same blocks
```

---

## 11. Usage Examples

### Start Workers (fetches data)

```bash
# Fetch Ethereum blocks 21890000 to 21890010
npx tsx src/index.ts --chain=ethereum --block=21890000 --targetBlock=21890010

# Fetch Polygon from latest to block 50000000
npx tsx src/index.ts --chain=polygon --targetBlock=50000000
```

### Start Processors (in separate terminal)

```bash
npx tsx src/startProcessors.ts
```

### Database Setup

```bash
# Run Prisma migrations
npx prisma migrate dev

# Seed chain_config table (required before running processors)
npx tsx prisma/seed.ts

# Initialize TimescaleDB hypertables (connect to PostgreSQL)
psql -U your_user -d your_database -f prisma/timescaledb_setup.sql
```

### Environment Variables

```bash
REDIS_HOST=localhost    # Redis host
REDIS_PORT=6379         # Redis port
DATABASE_URL=postgresql://user:password@localhost:5432/blockchain_db
```

---

## Summary

| Component                 | Purpose                         | Key Feature                              |
| ------------------------- | ------------------------------- | ---------------------------------------- |
| **RpcManager**            | RPC failover                    | Multi-provider rotation                  |
| **BlockFetcher**          | Block data                      | Full tx with timestamps                  |
| **EventFetcher**          | Event data                      | Address filtering                        |
| **BaseChainWorker**       | Fetch orchestration             | Dual-phase parallel                      |
| **TransactionProcessor**  | Native transfers + CEX analysis | Saves to `native_transfers`, `cex_flows` |
| **EventProcessor**        | Event grouping bridge           | EVENTS → GROUPED_EVENTS queue            |
| **GroupedEventProcessor** | Event decoding                  | Saves to `decoded_events`                |
| **EventDecoder**          | Raw → Structured events         | ethers.js Interface                      |
| **BullMQ Queues**         | Job distribution                | Retry with backoff                       |
| **cexAddress**            | CEX wallet registry             | Multi-chain address sets                 |
| **eventAttributes.json**  | Event signatures                | 50+ DeFi events                          |
| **Prisma + TimescaleDB**  | Data persistence                | Time-series optimization                 |
| **Storage Classes**       | Database operations             | Upsert + batch transactions              |
| **prisma/seed.ts**        | Database seeding                | Populates chain_config                   |

### Database Tables

| Category              | Table                  | Description                                |
| --------------------- | ---------------------- | ------------------------------------------ |
| Reference             | `chain_config`         | Chain metadata (id, name, symbol)          |
| Reference             | `tokens`               | ERC-20 token metadata                      |
| Reference             | `pools`                | DEX liquidity pool metadata                |
| Native Hypertable     | `native_transfers`     | Block-level native transfers               |
| Native Hypertable     | `cex_flows`            | Native CEX inflow/outflow per block        |
| Native Hypertable     | `decoded_events`       | Decoded smart contract events              |
| Stablecoin Hypertable | `stablecoin_transfers` | Block-level stablecoin transfers           |
| Stablecoin Hypertable | `stablecoin_cex_flows` | Stablecoin CEX flows per block             |
| Pool Hypertable       | `pool_swaps`           | Block-level swap volume per pool           |
| Pool Hypertable       | `pool_liquidity`       | Block-level liquidity changes (ADD/REMOVE) |
| Pool Hypertable       | `pool_fees`            | Block-level fees collected per pool        |

The system is designed for **reliability** (RPC failover, retries), **performance** (parallel phases, hypertables), **extensibility** (queue-based processing, configurable events), and **multi-chain support** (chain-aware address lookups, unified schema).
