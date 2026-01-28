/*
  Warnings:

  - The primary key for the `cex_flows` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `decoded_events` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `native_transfers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `pool_fees` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `pool_liquidity` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `pool_swaps` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `stablecoin_cex_flows` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `stablecoin_transfers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - A unique constraint covering the columns `[chainId,cexName,flowType,blockNumber,blockTimeStamp]` on the table `cex_flows` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chainId,blockNumber,blockTimeStamp]` on the table `native_transfers` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chainId,poolAddress,blockNumber,blockTimeStamp]` on the table `pool_fees` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chainId,poolAddress,liquidityType,blockNumber,blockTimeStamp]` on the table `pool_liquidity` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chainId,poolAddress,blockNumber,blockTimeStamp]` on the table `pool_swaps` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chainId,tokenAddress,cexName,flowType,blockNumber,blockTimeStamp]` on the table `stablecoin_cex_flows` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chainId,tokenAddress,blockNumber,blockTimeStamp]` on the table `stablecoin_transfers` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "cex_flows_chainId_cexName_flowType_blockNumber_key";

-- DropIndex
DROP INDEX "native_transfers_chainId_blockNumber_key";

-- DropIndex
DROP INDEX "pool_fees_chainId_poolAddress_blockNumber_key";

-- DropIndex
DROP INDEX "pool_liquidity_chainId_poolAddress_liquidityType_blockNumbe_key";

-- DropIndex
DROP INDEX "pool_swaps_chainId_poolAddress_blockNumber_key";

-- DropIndex
DROP INDEX "stablecoin_cex_flows_chainId_tokenAddress_cexName_flowType__key";

-- DropIndex
DROP INDEX "stablecoin_transfers_chainId_tokenAddress_blockNumber_key";

-- AlterTable
ALTER TABLE "cex_flows" DROP CONSTRAINT "cex_flows_pkey",
ADD CONSTRAINT "cex_flows_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- AlterTable
ALTER TABLE "decoded_events" DROP CONSTRAINT "decoded_events_pkey",
ADD CONSTRAINT "decoded_events_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- AlterTable
ALTER TABLE "native_transfers" DROP CONSTRAINT "native_transfers_pkey",
ADD CONSTRAINT "native_transfers_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- AlterTable
ALTER TABLE "pool_fees" DROP CONSTRAINT "pool_fees_pkey",
ADD CONSTRAINT "pool_fees_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- AlterTable
ALTER TABLE "pool_liquidity" DROP CONSTRAINT "pool_liquidity_pkey",
ADD CONSTRAINT "pool_liquidity_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- AlterTable
ALTER TABLE "pool_swaps" DROP CONSTRAINT "pool_swaps_pkey",
ADD CONSTRAINT "pool_swaps_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- AlterTable
ALTER TABLE "stablecoin_cex_flows" DROP CONSTRAINT "stablecoin_cex_flows_pkey",
ADD CONSTRAINT "stablecoin_cex_flows_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- AlterTable
ALTER TABLE "stablecoin_transfers" DROP CONSTRAINT "stablecoin_transfers_pkey",
ADD CONSTRAINT "stablecoin_transfers_pkey" PRIMARY KEY ("id", "blockTimeStamp");

-- CreateIndex
CREATE UNIQUE INDEX "cex_flows_chainId_cexName_flowType_blockNumber_blockTimeSta_key" ON "cex_flows"("chainId", "cexName", "flowType", "blockNumber", "blockTimeStamp");

-- CreateIndex
CREATE UNIQUE INDEX "native_transfers_chainId_blockNumber_blockTimeStamp_key" ON "native_transfers"("chainId", "blockNumber", "blockTimeStamp");

-- CreateIndex
CREATE UNIQUE INDEX "pool_fees_chainId_poolAddress_blockNumber_blockTimeStamp_key" ON "pool_fees"("chainId", "poolAddress", "blockNumber", "blockTimeStamp");

-- CreateIndex
CREATE UNIQUE INDEX "pool_liquidity_chainId_poolAddress_liquidityType_blockNumbe_key" ON "pool_liquidity"("chainId", "poolAddress", "liquidityType", "blockNumber", "blockTimeStamp");

-- CreateIndex
CREATE UNIQUE INDEX "pool_swaps_chainId_poolAddress_blockNumber_blockTimeStamp_key" ON "pool_swaps"("chainId", "poolAddress", "blockNumber", "blockTimeStamp");

-- CreateIndex
CREATE UNIQUE INDEX "stablecoin_cex_flows_chainId_tokenAddress_cexName_flowType__key" ON "stablecoin_cex_flows"("chainId", "tokenAddress", "cexName", "flowType", "blockNumber", "blockTimeStamp");

-- CreateIndex
CREATE UNIQUE INDEX "stablecoin_transfers_chainId_tokenAddress_blockNumber_block_key" ON "stablecoin_transfers"("chainId", "tokenAddress", "blockNumber", "blockTimeStamp");
