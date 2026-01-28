-- CreateEnum
CREATE TYPE "FlowType" AS ENUM ('INFLOW', 'OUTFLOW');

-- CreateEnum
CREATE TYPE "LiquidityType" AS ENUM ('ADD', 'REMOVE');

-- CreateTable
CREATE TABLE "chain_config" (
    "chainId" INTEGER NOT NULL,
    "networkName" TEXT NOT NULL,
    "tokenSymbol" TEXT NOT NULL,

    CONSTRAINT "chain_config_pkey" PRIMARY KEY ("chainId")
);

-- CreateTable
CREATE TABLE "tokens" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "tokenAddress" TEXT NOT NULL,
    "tokenName" TEXT NOT NULL,
    "tokenSymbol" TEXT NOT NULL,
    "tokenDecimal" INTEGER NOT NULL,

    CONSTRAINT "tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pools" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "poolAddress" TEXT NOT NULL,
    "token0Address" TEXT NOT NULL,
    "token1Address" TEXT NOT NULL,
    "poolSymbol" TEXT NOT NULL,
    "dexName" TEXT NOT NULL,
    "dexVersion" TEXT,
    "fees" INTEGER[],

    CONSTRAINT "pools_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "native_transfers" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockHash" TEXT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "totalAmount" TEXT NOT NULL,
    "transactionHashes" TEXT[],

    CONSTRAINT "native_transfers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cex_flows" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "cexName" TEXT NOT NULL,
    "flowType" "FlowType" NOT NULL,
    "totalAmount" TEXT NOT NULL,
    "totalAmountHuman" TEXT NOT NULL,
    "transactionHashes" TEXT[],
    "transactionCount" INTEGER NOT NULL,

    CONSTRAINT "cex_flows_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "decoded_events" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "contractAddress" TEXT NOT NULL,
    "transactionHash" TEXT NOT NULL,
    "transactionIndex" INTEGER NOT NULL,
    "eventName" TEXT NOT NULL,
    "eventArgs" JSONB NOT NULL,

    CONSTRAINT "decoded_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stablecoin_transfers" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "tokenAddress" TEXT NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockHash" TEXT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "totalAmount" TEXT NOT NULL,
    "totalAmountHuman" TEXT NOT NULL,
    "transactionHashes" TEXT[],
    "transactionCount" INTEGER NOT NULL,

    CONSTRAINT "stablecoin_transfers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stablecoin_cex_flows" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "tokenAddress" TEXT NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "cexName" TEXT NOT NULL,
    "flowType" "FlowType" NOT NULL,
    "totalAmount" TEXT NOT NULL,
    "totalAmountHuman" TEXT NOT NULL,
    "transactionHashes" TEXT[],
    "transactionCount" INTEGER NOT NULL,

    CONSTRAINT "stablecoin_cex_flows_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pool_swaps" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "poolAddress" TEXT NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "volumeToken0" TEXT NOT NULL,
    "volumeToken0Human" TEXT NOT NULL,
    "volumeToken1" TEXT NOT NULL,
    "volumeToken1Human" TEXT NOT NULL,
    "swapCount" INTEGER NOT NULL,
    "transactionHashes" TEXT[],

    CONSTRAINT "pool_swaps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pool_liquidity" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "poolAddress" TEXT NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "liquidityType" "LiquidityType" NOT NULL,
    "amountToken0" TEXT NOT NULL,
    "amountToken0Human" TEXT NOT NULL,
    "amountToken1" TEXT NOT NULL,
    "amountToken1Human" TEXT NOT NULL,
    "transactionCount" INTEGER NOT NULL,
    "transactionHashes" TEXT[],

    CONSTRAINT "pool_liquidity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pool_fees" (
    "id" TEXT NOT NULL,
    "chainId" INTEGER NOT NULL,
    "poolAddress" TEXT NOT NULL,
    "blockNumber" BIGINT NOT NULL,
    "blockTimeStamp" TIMESTAMP(3) NOT NULL,
    "feesToken0" TEXT NOT NULL,
    "feesToken0Human" TEXT NOT NULL,
    "feesToken1" TEXT NOT NULL,
    "feesToken1Human" TEXT NOT NULL,
    "collectCount" INTEGER NOT NULL,
    "transactionHashes" TEXT[],

    CONSTRAINT "pool_fees_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "tokens_tokenSymbol_idx" ON "tokens"("tokenSymbol");

-- CreateIndex
CREATE UNIQUE INDEX "tokens_chainId_tokenAddress_key" ON "tokens"("chainId", "tokenAddress");

-- CreateIndex
CREATE INDEX "pools_dexName_idx" ON "pools"("dexName");

-- CreateIndex
CREATE INDEX "pools_token0Address_idx" ON "pools"("token0Address");

-- CreateIndex
CREATE INDEX "pools_token1Address_idx" ON "pools"("token1Address");

-- CreateIndex
CREATE UNIQUE INDEX "pools_chainId_poolAddress_key" ON "pools"("chainId", "poolAddress");

-- CreateIndex
CREATE INDEX "native_transfers_chainId_blockTimeStamp_idx" ON "native_transfers"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "native_transfers_blockNumber_idx" ON "native_transfers"("blockNumber");

-- CreateIndex
CREATE UNIQUE INDEX "native_transfers_chainId_blockNumber_key" ON "native_transfers"("chainId", "blockNumber");

-- CreateIndex
CREATE INDEX "cex_flows_chainId_blockTimeStamp_idx" ON "cex_flows"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "cex_flows_cexName_flowType_idx" ON "cex_flows"("cexName", "flowType");

-- CreateIndex
CREATE INDEX "cex_flows_blockNumber_idx" ON "cex_flows"("blockNumber");

-- CreateIndex
CREATE INDEX "cex_flows_chainId_cexName_flowType_idx" ON "cex_flows"("chainId", "cexName", "flowType");

-- CreateIndex
CREATE UNIQUE INDEX "cex_flows_chainId_cexName_flowType_blockNumber_key" ON "cex_flows"("chainId", "cexName", "flowType", "blockNumber");

-- CreateIndex
CREATE INDEX "decoded_events_chainId_blockTimeStamp_idx" ON "decoded_events"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "decoded_events_contractAddress_idx" ON "decoded_events"("contractAddress");

-- CreateIndex
CREATE INDEX "decoded_events_eventName_idx" ON "decoded_events"("eventName");

-- CreateIndex
CREATE INDEX "decoded_events_transactionHash_idx" ON "decoded_events"("transactionHash");

-- CreateIndex
CREATE INDEX "stablecoin_transfers_chainId_blockTimeStamp_idx" ON "stablecoin_transfers"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "stablecoin_transfers_chainId_tokenAddress_idx" ON "stablecoin_transfers"("chainId", "tokenAddress");

-- CreateIndex
CREATE INDEX "stablecoin_transfers_blockNumber_idx" ON "stablecoin_transfers"("blockNumber");

-- CreateIndex
CREATE UNIQUE INDEX "stablecoin_transfers_chainId_tokenAddress_blockNumber_key" ON "stablecoin_transfers"("chainId", "tokenAddress", "blockNumber");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_chainId_blockTimeStamp_idx" ON "stablecoin_cex_flows"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_chainId_cexName_flowType_idx" ON "stablecoin_cex_flows"("chainId", "cexName", "flowType");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_chainId_tokenAddress_flowType_idx" ON "stablecoin_cex_flows"("chainId", "tokenAddress", "flowType");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_blockNumber_idx" ON "stablecoin_cex_flows"("blockNumber");

-- CreateIndex
CREATE UNIQUE INDEX "stablecoin_cex_flows_chainId_tokenAddress_cexName_flowType__key" ON "stablecoin_cex_flows"("chainId", "tokenAddress", "cexName", "flowType", "blockNumber");

-- CreateIndex
CREATE INDEX "pool_swaps_chainId_blockTimeStamp_idx" ON "pool_swaps"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "pool_swaps_chainId_poolAddress_idx" ON "pool_swaps"("chainId", "poolAddress");

-- CreateIndex
CREATE INDEX "pool_swaps_blockNumber_idx" ON "pool_swaps"("blockNumber");

-- CreateIndex
CREATE UNIQUE INDEX "pool_swaps_chainId_poolAddress_blockNumber_key" ON "pool_swaps"("chainId", "poolAddress", "blockNumber");

-- CreateIndex
CREATE INDEX "pool_liquidity_chainId_blockTimeStamp_idx" ON "pool_liquidity"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "pool_liquidity_chainId_poolAddress_liquidityType_idx" ON "pool_liquidity"("chainId", "poolAddress", "liquidityType");

-- CreateIndex
CREATE INDEX "pool_liquidity_blockNumber_idx" ON "pool_liquidity"("blockNumber");

-- CreateIndex
CREATE UNIQUE INDEX "pool_liquidity_chainId_poolAddress_liquidityType_blockNumbe_key" ON "pool_liquidity"("chainId", "poolAddress", "liquidityType", "blockNumber");

-- CreateIndex
CREATE INDEX "pool_fees_chainId_blockTimeStamp_idx" ON "pool_fees"("chainId", "blockTimeStamp");

-- CreateIndex
CREATE INDEX "pool_fees_chainId_poolAddress_idx" ON "pool_fees"("chainId", "poolAddress");

-- CreateIndex
CREATE INDEX "pool_fees_blockNumber_idx" ON "pool_fees"("blockNumber");

-- CreateIndex
CREATE UNIQUE INDEX "pool_fees_chainId_poolAddress_blockNumber_key" ON "pool_fees"("chainId", "poolAddress", "blockNumber");

-- AddForeignKey
ALTER TABLE "tokens" ADD CONSTRAINT "tokens_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pools" ADD CONSTRAINT "pools_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pools" ADD CONSTRAINT "pools_chainId_token0Address_fkey" FOREIGN KEY ("chainId", "token0Address") REFERENCES "tokens"("chainId", "tokenAddress") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pools" ADD CONSTRAINT "pools_chainId_token1Address_fkey" FOREIGN KEY ("chainId", "token1Address") REFERENCES "tokens"("chainId", "tokenAddress") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "native_transfers" ADD CONSTRAINT "native_transfers_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cex_flows" ADD CONSTRAINT "cex_flows_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "decoded_events" ADD CONSTRAINT "decoded_events_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_transfers" ADD CONSTRAINT "stablecoin_transfers_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_transfers" ADD CONSTRAINT "stablecoin_transfers_chainId_tokenAddress_fkey" FOREIGN KEY ("chainId", "tokenAddress") REFERENCES "tokens"("chainId", "tokenAddress") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_cex_flows" ADD CONSTRAINT "stablecoin_cex_flows_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_cex_flows" ADD CONSTRAINT "stablecoin_cex_flows_chainId_tokenAddress_fkey" FOREIGN KEY ("chainId", "tokenAddress") REFERENCES "tokens"("chainId", "tokenAddress") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_swaps" ADD CONSTRAINT "pool_swaps_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_swaps" ADD CONSTRAINT "pool_swaps_chainId_poolAddress_fkey" FOREIGN KEY ("chainId", "poolAddress") REFERENCES "pools"("chainId", "poolAddress") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_liquidity" ADD CONSTRAINT "pool_liquidity_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_liquidity" ADD CONSTRAINT "pool_liquidity_chainId_poolAddress_fkey" FOREIGN KEY ("chainId", "poolAddress") REFERENCES "pools"("chainId", "poolAddress") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_fees" ADD CONSTRAINT "pool_fees_chainId_fkey" FOREIGN KEY ("chainId") REFERENCES "chain_config"("chainId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_fees" ADD CONSTRAINT "pool_fees_chainId_poolAddress_fkey" FOREIGN KEY ("chainId", "poolAddress") REFERENCES "pools"("chainId", "poolAddress") ON DELETE RESTRICT ON UPDATE CASCADE;
