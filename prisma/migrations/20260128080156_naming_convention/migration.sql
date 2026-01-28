/*
  Warnings:

  - The primary key for the `cex_flows` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `blockNumber` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `cexName` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `flowType` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmount` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmountHuman` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `transactionCount` on the `cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHashes` on the `cex_flows` table. All the data in the column will be lost.
  - The primary key for the `chain_config` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `chainId` on the `chain_config` table. All the data in the column will be lost.
  - You are about to drop the column `networkName` on the `chain_config` table. All the data in the column will be lost.
  - You are about to drop the column `tokenSymbol` on the `chain_config` table. All the data in the column will be lost.
  - The primary key for the `decoded_events` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `blockNumber` on the `decoded_events` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `decoded_events` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `decoded_events` table. All the data in the column will be lost.
  - You are about to drop the column `contractAddress` on the `decoded_events` table. All the data in the column will be lost.
  - You are about to drop the column `eventArgs` on the `decoded_events` table. All the data in the column will be lost.
  - You are about to drop the column `eventName` on the `decoded_events` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHash` on the `decoded_events` table. All the data in the column will be lost.
  - You are about to drop the column `transactionIndex` on the `decoded_events` table. All the data in the column will be lost.
  - The primary key for the `native_transfers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `blockHash` on the `native_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `blockNumber` on the `native_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `native_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `native_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmount` on the `native_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHashes` on the `native_transfers` table. All the data in the column will be lost.
  - The primary key for the `pool_fees` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `blockNumber` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `collectCount` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `feesToken0` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `feesToken0Human` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `feesToken1` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `feesToken1Human` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `poolAddress` on the `pool_fees` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHashes` on the `pool_fees` table. All the data in the column will be lost.
  - The primary key for the `pool_liquidity` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `amountToken0` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `amountToken0Human` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `amountToken1` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `amountToken1Human` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `blockNumber` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `liquidityType` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `poolAddress` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `transactionCount` on the `pool_liquidity` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHashes` on the `pool_liquidity` table. All the data in the column will be lost.
  - The primary key for the `pool_swaps` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `blockNumber` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `poolAddress` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `swapCount` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHashes` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `volumeToken0` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `volumeToken0Human` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `volumeToken1` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `volumeToken1Human` on the `pool_swaps` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `pools` table. All the data in the column will be lost.
  - You are about to drop the column `dexName` on the `pools` table. All the data in the column will be lost.
  - You are about to drop the column `dexVersion` on the `pools` table. All the data in the column will be lost.
  - You are about to drop the column `poolAddress` on the `pools` table. All the data in the column will be lost.
  - You are about to drop the column `poolSymbol` on the `pools` table. All the data in the column will be lost.
  - You are about to drop the column `token0Address` on the `pools` table. All the data in the column will be lost.
  - You are about to drop the column `token1Address` on the `pools` table. All the data in the column will be lost.
  - The primary key for the `stablecoin_cex_flows` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `blockNumber` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `cexName` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `flowType` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `tokenAddress` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmount` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmountHuman` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `transactionCount` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHashes` on the `stablecoin_cex_flows` table. All the data in the column will be lost.
  - The primary key for the `stablecoin_transfers` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `blockHash` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `blockNumber` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `blockTimeStamp` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `tokenAddress` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmount` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `totalAmountHuman` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `transactionCount` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `transactionHashes` on the `stablecoin_transfers` table. All the data in the column will be lost.
  - You are about to drop the column `chainId` on the `tokens` table. All the data in the column will be lost.
  - You are about to drop the column `tokenAddress` on the `tokens` table. All the data in the column will be lost.
  - You are about to drop the column `tokenDecimal` on the `tokens` table. All the data in the column will be lost.
  - You are about to drop the column `tokenName` on the `tokens` table. All the data in the column will be lost.
  - You are about to drop the column `tokenSymbol` on the `tokens` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[chain_id,cex_name,flow_type,block_number,block_time_stamp]` on the table `cex_flows` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,block_number,block_time_stamp]` on the table `native_transfers` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,pool_address,block_number,block_time_stamp]` on the table `pool_fees` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,pool_address,liquidity_type,block_number,block_time_stamp]` on the table `pool_liquidity` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,pool_address,block_number,block_time_stamp]` on the table `pool_swaps` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,pool_address]` on the table `pools` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,token_address,cex_name,flow_type,block_number,block_time_stamp]` on the table `stablecoin_cex_flows` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,token_address,block_number,block_time_stamp]` on the table `stablecoin_transfers` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[chain_id,token_address]` on the table `tokens` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `block_number` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `cex_name` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `flow_type` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount_human` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transaction_count` to the `cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `chain_config` table without a default value. This is not possible if the table is not empty.
  - Added the required column `network_name` to the `chain_config` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_symbol` to the `chain_config` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_number` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `contract_address` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `event_args` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `event_name` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transaction_hash` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transaction_index` to the `decoded_events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_hash` to the `native_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_number` to the `native_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `native_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `native_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount` to the `native_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_number` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `collect_count` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fees_token_0` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fees_token_0_human` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fees_token_1` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fees_token_1_human` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `pool_address` to the `pool_fees` table without a default value. This is not possible if the table is not empty.
  - Added the required column `amount_token_0` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `amount_token_0_human` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `amount_token_1` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `amount_token_1_human` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_number` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `liquidity_type` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `pool_address` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transaction_count` to the `pool_liquidity` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_number` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `pool_address` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `swap_count` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `volume_token_0` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `volume_token_0_human` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `volume_token_1` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `volume_token_1_human` to the `pool_swaps` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `pools` table without a default value. This is not possible if the table is not empty.
  - Added the required column `dex_name` to the `pools` table without a default value. This is not possible if the table is not empty.
  - Added the required column `pool_address` to the `pools` table without a default value. This is not possible if the table is not empty.
  - Added the required column `pool_symbol` to the `pools` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_0_address` to the `pools` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_1_address` to the `pools` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_number` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `cex_name` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `flow_type` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_address` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount_human` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transaction_count` to the `stablecoin_cex_flows` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_hash` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_number` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `block_time_stamp` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_address` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `total_amount_human` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transaction_count` to the `stablecoin_transfers` table without a default value. This is not possible if the table is not empty.
  - Added the required column `chain_id` to the `tokens` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_address` to the `tokens` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_decimal` to the `tokens` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_name` to the `tokens` table without a default value. This is not possible if the table is not empty.
  - Added the required column `token_symbol` to the `tokens` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "cex_flows" DROP CONSTRAINT "cex_flows_chainId_fkey";

-- DropForeignKey
ALTER TABLE "decoded_events" DROP CONSTRAINT "decoded_events_chainId_fkey";

-- DropForeignKey
ALTER TABLE "native_transfers" DROP CONSTRAINT "native_transfers_chainId_fkey";

-- DropForeignKey
ALTER TABLE "pool_fees" DROP CONSTRAINT "pool_fees_chainId_fkey";

-- DropForeignKey
ALTER TABLE "pool_fees" DROP CONSTRAINT "pool_fees_chainId_poolAddress_fkey";

-- DropForeignKey
ALTER TABLE "pool_liquidity" DROP CONSTRAINT "pool_liquidity_chainId_fkey";

-- DropForeignKey
ALTER TABLE "pool_liquidity" DROP CONSTRAINT "pool_liquidity_chainId_poolAddress_fkey";

-- DropForeignKey
ALTER TABLE "pool_swaps" DROP CONSTRAINT "pool_swaps_chainId_fkey";

-- DropForeignKey
ALTER TABLE "pool_swaps" DROP CONSTRAINT "pool_swaps_chainId_poolAddress_fkey";

-- DropForeignKey
ALTER TABLE "pools" DROP CONSTRAINT "pools_chainId_fkey";

-- DropForeignKey
ALTER TABLE "pools" DROP CONSTRAINT "pools_chainId_token0Address_fkey";

-- DropForeignKey
ALTER TABLE "pools" DROP CONSTRAINT "pools_chainId_token1Address_fkey";

-- DropForeignKey
ALTER TABLE "stablecoin_cex_flows" DROP CONSTRAINT "stablecoin_cex_flows_chainId_fkey";

-- DropForeignKey
ALTER TABLE "stablecoin_cex_flows" DROP CONSTRAINT "stablecoin_cex_flows_chainId_tokenAddress_fkey";

-- DropForeignKey
ALTER TABLE "stablecoin_transfers" DROP CONSTRAINT "stablecoin_transfers_chainId_fkey";

-- DropForeignKey
ALTER TABLE "stablecoin_transfers" DROP CONSTRAINT "stablecoin_transfers_chainId_tokenAddress_fkey";

-- DropForeignKey
ALTER TABLE "tokens" DROP CONSTRAINT "tokens_chainId_fkey";

-- DropIndex
DROP INDEX "cex_flows_blockNumber_idx";

-- DropIndex
DROP INDEX "cex_flows_cexName_flowType_idx";

-- DropIndex
DROP INDEX "cex_flows_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "cex_flows_chainId_cexName_flowType_blockNumber_blockTimeSta_key";

-- DropIndex
DROP INDEX "cex_flows_chainId_cexName_flowType_idx";

-- DropIndex
DROP INDEX "decoded_events_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "decoded_events_contractAddress_idx";

-- DropIndex
DROP INDEX "decoded_events_eventName_idx";

-- DropIndex
DROP INDEX "decoded_events_transactionHash_idx";

-- DropIndex
DROP INDEX "native_transfers_blockNumber_idx";

-- DropIndex
DROP INDEX "native_transfers_chainId_blockNumber_blockTimeStamp_key";

-- DropIndex
DROP INDEX "native_transfers_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "pool_fees_blockNumber_idx";

-- DropIndex
DROP INDEX "pool_fees_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "pool_fees_chainId_poolAddress_blockNumber_blockTimeStamp_key";

-- DropIndex
DROP INDEX "pool_fees_chainId_poolAddress_idx";

-- DropIndex
DROP INDEX "pool_liquidity_blockNumber_idx";

-- DropIndex
DROP INDEX "pool_liquidity_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "pool_liquidity_chainId_poolAddress_liquidityType_blockNumbe_key";

-- DropIndex
DROP INDEX "pool_liquidity_chainId_poolAddress_liquidityType_idx";

-- DropIndex
DROP INDEX "pool_swaps_blockNumber_idx";

-- DropIndex
DROP INDEX "pool_swaps_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "pool_swaps_chainId_poolAddress_blockNumber_blockTimeStamp_key";

-- DropIndex
DROP INDEX "pool_swaps_chainId_poolAddress_idx";

-- DropIndex
DROP INDEX "pools_chainId_poolAddress_key";

-- DropIndex
DROP INDEX "pools_dexName_idx";

-- DropIndex
DROP INDEX "pools_token0Address_idx";

-- DropIndex
DROP INDEX "pools_token1Address_idx";

-- DropIndex
DROP INDEX "stablecoin_cex_flows_blockNumber_idx";

-- DropIndex
DROP INDEX "stablecoin_cex_flows_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "stablecoin_cex_flows_chainId_cexName_flowType_idx";

-- DropIndex
DROP INDEX "stablecoin_cex_flows_chainId_tokenAddress_cexName_flowType__key";

-- DropIndex
DROP INDEX "stablecoin_cex_flows_chainId_tokenAddress_flowType_idx";

-- DropIndex
DROP INDEX "stablecoin_transfers_blockNumber_idx";

-- DropIndex
DROP INDEX "stablecoin_transfers_chainId_blockTimeStamp_idx";

-- DropIndex
DROP INDEX "stablecoin_transfers_chainId_tokenAddress_blockNumber_block_key";

-- DropIndex
DROP INDEX "stablecoin_transfers_chainId_tokenAddress_idx";

-- DropIndex
DROP INDEX "tokens_chainId_tokenAddress_key";

-- DropIndex
DROP INDEX "tokens_tokenSymbol_idx";

-- AlterTable
ALTER TABLE "cex_flows" DROP CONSTRAINT "cex_flows_pkey",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "cexName",
DROP COLUMN "chainId",
DROP COLUMN "flowType",
DROP COLUMN "totalAmount",
DROP COLUMN "totalAmountHuman",
DROP COLUMN "transactionCount",
DROP COLUMN "transactionHashes",
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "cex_name" TEXT NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "flow_type" "FlowType" NOT NULL,
ADD COLUMN     "total_amount" TEXT NOT NULL,
ADD COLUMN     "total_amount_human" TEXT NOT NULL,
ADD COLUMN     "transaction_count" INTEGER NOT NULL,
ADD COLUMN     "transaction_hashes" TEXT[],
ADD CONSTRAINT "cex_flows_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "chain_config" DROP CONSTRAINT "chain_config_pkey",
DROP COLUMN "chainId",
DROP COLUMN "networkName",
DROP COLUMN "tokenSymbol",
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "network_name" TEXT NOT NULL,
ADD COLUMN     "token_symbol" TEXT NOT NULL,
ADD CONSTRAINT "chain_config_pkey" PRIMARY KEY ("chain_id");

-- AlterTable
ALTER TABLE "decoded_events" DROP CONSTRAINT "decoded_events_pkey",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "chainId",
DROP COLUMN "contractAddress",
DROP COLUMN "eventArgs",
DROP COLUMN "eventName",
DROP COLUMN "transactionHash",
DROP COLUMN "transactionIndex",
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "contract_address" TEXT NOT NULL,
ADD COLUMN     "event_args" JSONB NOT NULL,
ADD COLUMN     "event_name" TEXT NOT NULL,
ADD COLUMN     "transaction_hash" TEXT NOT NULL,
ADD COLUMN     "transaction_index" INTEGER NOT NULL,
ADD CONSTRAINT "decoded_events_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "native_transfers" DROP CONSTRAINT "native_transfers_pkey",
DROP COLUMN "blockHash",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "chainId",
DROP COLUMN "totalAmount",
DROP COLUMN "transactionHashes",
ADD COLUMN     "block_hash" TEXT NOT NULL,
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "total_amount" TEXT NOT NULL,
ADD COLUMN     "transaction_hashes" TEXT[],
ADD CONSTRAINT "native_transfers_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "pool_fees" DROP CONSTRAINT "pool_fees_pkey",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "chainId",
DROP COLUMN "collectCount",
DROP COLUMN "feesToken0",
DROP COLUMN "feesToken0Human",
DROP COLUMN "feesToken1",
DROP COLUMN "feesToken1Human",
DROP COLUMN "poolAddress",
DROP COLUMN "transactionHashes",
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "collect_count" INTEGER NOT NULL,
ADD COLUMN     "fees_token_0" TEXT NOT NULL,
ADD COLUMN     "fees_token_0_human" TEXT NOT NULL,
ADD COLUMN     "fees_token_1" TEXT NOT NULL,
ADD COLUMN     "fees_token_1_human" TEXT NOT NULL,
ADD COLUMN     "pool_address" TEXT NOT NULL,
ADD COLUMN     "transaction_hashes" TEXT[],
ADD CONSTRAINT "pool_fees_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "pool_liquidity" DROP CONSTRAINT "pool_liquidity_pkey",
DROP COLUMN "amountToken0",
DROP COLUMN "amountToken0Human",
DROP COLUMN "amountToken1",
DROP COLUMN "amountToken1Human",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "chainId",
DROP COLUMN "liquidityType",
DROP COLUMN "poolAddress",
DROP COLUMN "transactionCount",
DROP COLUMN "transactionHashes",
ADD COLUMN     "amount_token_0" TEXT NOT NULL,
ADD COLUMN     "amount_token_0_human" TEXT NOT NULL,
ADD COLUMN     "amount_token_1" TEXT NOT NULL,
ADD COLUMN     "amount_token_1_human" TEXT NOT NULL,
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "liquidity_type" "LiquidityType" NOT NULL,
ADD COLUMN     "pool_address" TEXT NOT NULL,
ADD COLUMN     "transaction_count" INTEGER NOT NULL,
ADD COLUMN     "transaction_hashes" TEXT[],
ADD CONSTRAINT "pool_liquidity_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "pool_swaps" DROP CONSTRAINT "pool_swaps_pkey",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "chainId",
DROP COLUMN "poolAddress",
DROP COLUMN "swapCount",
DROP COLUMN "transactionHashes",
DROP COLUMN "volumeToken0",
DROP COLUMN "volumeToken0Human",
DROP COLUMN "volumeToken1",
DROP COLUMN "volumeToken1Human",
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "pool_address" TEXT NOT NULL,
ADD COLUMN     "swap_count" INTEGER NOT NULL,
ADD COLUMN     "transaction_hashes" TEXT[],
ADD COLUMN     "volume_token_0" TEXT NOT NULL,
ADD COLUMN     "volume_token_0_human" TEXT NOT NULL,
ADD COLUMN     "volume_token_1" TEXT NOT NULL,
ADD COLUMN     "volume_token_1_human" TEXT NOT NULL,
ADD CONSTRAINT "pool_swaps_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "pools" DROP COLUMN "chainId",
DROP COLUMN "dexName",
DROP COLUMN "dexVersion",
DROP COLUMN "poolAddress",
DROP COLUMN "poolSymbol",
DROP COLUMN "token0Address",
DROP COLUMN "token1Address",
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "dex_name" TEXT NOT NULL,
ADD COLUMN     "dex_version" TEXT,
ADD COLUMN     "pool_address" TEXT NOT NULL,
ADD COLUMN     "pool_symbol" TEXT NOT NULL,
ADD COLUMN     "token_0_address" TEXT NOT NULL,
ADD COLUMN     "token_1_address" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "stablecoin_cex_flows" DROP CONSTRAINT "stablecoin_cex_flows_pkey",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "cexName",
DROP COLUMN "chainId",
DROP COLUMN "flowType",
DROP COLUMN "tokenAddress",
DROP COLUMN "totalAmount",
DROP COLUMN "totalAmountHuman",
DROP COLUMN "transactionCount",
DROP COLUMN "transactionHashes",
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "cex_name" TEXT NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "flow_type" "FlowType" NOT NULL,
ADD COLUMN     "token_address" TEXT NOT NULL,
ADD COLUMN     "total_amount" TEXT NOT NULL,
ADD COLUMN     "total_amount_human" TEXT NOT NULL,
ADD COLUMN     "transaction_count" INTEGER NOT NULL,
ADD COLUMN     "transaction_hashes" TEXT[],
ADD CONSTRAINT "stablecoin_cex_flows_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "stablecoin_transfers" DROP CONSTRAINT "stablecoin_transfers_pkey",
DROP COLUMN "blockHash",
DROP COLUMN "blockNumber",
DROP COLUMN "blockTimeStamp",
DROP COLUMN "chainId",
DROP COLUMN "tokenAddress",
DROP COLUMN "totalAmount",
DROP COLUMN "totalAmountHuman",
DROP COLUMN "transactionCount",
DROP COLUMN "transactionHashes",
ADD COLUMN     "block_hash" TEXT NOT NULL,
ADD COLUMN     "block_number" BIGINT NOT NULL,
ADD COLUMN     "block_time_stamp" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "token_address" TEXT NOT NULL,
ADD COLUMN     "total_amount" TEXT NOT NULL,
ADD COLUMN     "total_amount_human" TEXT NOT NULL,
ADD COLUMN     "transaction_count" INTEGER NOT NULL,
ADD COLUMN     "transaction_hashes" TEXT[],
ADD CONSTRAINT "stablecoin_transfers_pkey" PRIMARY KEY ("id", "block_time_stamp");

-- AlterTable
ALTER TABLE "tokens" DROP COLUMN "chainId",
DROP COLUMN "tokenAddress",
DROP COLUMN "tokenDecimal",
DROP COLUMN "tokenName",
DROP COLUMN "tokenSymbol",
ADD COLUMN     "chain_id" INTEGER NOT NULL,
ADD COLUMN     "token_address" TEXT NOT NULL,
ADD COLUMN     "token_decimal" INTEGER NOT NULL,
ADD COLUMN     "token_name" TEXT NOT NULL,
ADD COLUMN     "token_symbol" TEXT NOT NULL;

-- CreateIndex
CREATE INDEX "cex_flows_chain_id_block_time_stamp_idx" ON "cex_flows"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "cex_flows_cex_name_flow_type_idx" ON "cex_flows"("cex_name", "flow_type");

-- CreateIndex
CREATE INDEX "cex_flows_block_number_idx" ON "cex_flows"("block_number");

-- CreateIndex
CREATE INDEX "cex_flows_chain_id_cex_name_flow_type_idx" ON "cex_flows"("chain_id", "cex_name", "flow_type");

-- CreateIndex
CREATE UNIQUE INDEX "cex_flows_chain_id_cex_name_flow_type_block_number_block_ti_key" ON "cex_flows"("chain_id", "cex_name", "flow_type", "block_number", "block_time_stamp");

-- CreateIndex
CREATE INDEX "decoded_events_chain_id_block_time_stamp_idx" ON "decoded_events"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "decoded_events_contract_address_idx" ON "decoded_events"("contract_address");

-- CreateIndex
CREATE INDEX "decoded_events_event_name_idx" ON "decoded_events"("event_name");

-- CreateIndex
CREATE INDEX "decoded_events_transaction_hash_idx" ON "decoded_events"("transaction_hash");

-- CreateIndex
CREATE INDEX "native_transfers_chain_id_block_time_stamp_idx" ON "native_transfers"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "native_transfers_block_number_idx" ON "native_transfers"("block_number");

-- CreateIndex
CREATE UNIQUE INDEX "native_transfers_chain_id_block_number_block_time_stamp_key" ON "native_transfers"("chain_id", "block_number", "block_time_stamp");

-- CreateIndex
CREATE INDEX "pool_fees_chain_id_block_time_stamp_idx" ON "pool_fees"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "pool_fees_chain_id_pool_address_idx" ON "pool_fees"("chain_id", "pool_address");

-- CreateIndex
CREATE INDEX "pool_fees_block_number_idx" ON "pool_fees"("block_number");

-- CreateIndex
CREATE UNIQUE INDEX "pool_fees_chain_id_pool_address_block_number_block_time_sta_key" ON "pool_fees"("chain_id", "pool_address", "block_number", "block_time_stamp");

-- CreateIndex
CREATE INDEX "pool_liquidity_chain_id_block_time_stamp_idx" ON "pool_liquidity"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "pool_liquidity_chain_id_pool_address_liquidity_type_idx" ON "pool_liquidity"("chain_id", "pool_address", "liquidity_type");

-- CreateIndex
CREATE INDEX "pool_liquidity_block_number_idx" ON "pool_liquidity"("block_number");

-- CreateIndex
CREATE UNIQUE INDEX "pool_liquidity_chain_id_pool_address_liquidity_type_block_n_key" ON "pool_liquidity"("chain_id", "pool_address", "liquidity_type", "block_number", "block_time_stamp");

-- CreateIndex
CREATE INDEX "pool_swaps_chain_id_block_time_stamp_idx" ON "pool_swaps"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "pool_swaps_chain_id_pool_address_idx" ON "pool_swaps"("chain_id", "pool_address");

-- CreateIndex
CREATE INDEX "pool_swaps_block_number_idx" ON "pool_swaps"("block_number");

-- CreateIndex
CREATE UNIQUE INDEX "pool_swaps_chain_id_pool_address_block_number_block_time_st_key" ON "pool_swaps"("chain_id", "pool_address", "block_number", "block_time_stamp");

-- CreateIndex
CREATE INDEX "pools_dex_name_idx" ON "pools"("dex_name");

-- CreateIndex
CREATE INDEX "pools_token_0_address_idx" ON "pools"("token_0_address");

-- CreateIndex
CREATE INDEX "pools_token_1_address_idx" ON "pools"("token_1_address");

-- CreateIndex
CREATE UNIQUE INDEX "pools_chain_id_pool_address_key" ON "pools"("chain_id", "pool_address");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_chain_id_block_time_stamp_idx" ON "stablecoin_cex_flows"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_chain_id_cex_name_flow_type_idx" ON "stablecoin_cex_flows"("chain_id", "cex_name", "flow_type");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_chain_id_token_address_flow_type_idx" ON "stablecoin_cex_flows"("chain_id", "token_address", "flow_type");

-- CreateIndex
CREATE INDEX "stablecoin_cex_flows_block_number_idx" ON "stablecoin_cex_flows"("block_number");

-- CreateIndex
CREATE UNIQUE INDEX "stablecoin_cex_flows_chain_id_token_address_cex_name_flow_t_key" ON "stablecoin_cex_flows"("chain_id", "token_address", "cex_name", "flow_type", "block_number", "block_time_stamp");

-- CreateIndex
CREATE INDEX "stablecoin_transfers_chain_id_block_time_stamp_idx" ON "stablecoin_transfers"("chain_id", "block_time_stamp");

-- CreateIndex
CREATE INDEX "stablecoin_transfers_chain_id_token_address_idx" ON "stablecoin_transfers"("chain_id", "token_address");

-- CreateIndex
CREATE INDEX "stablecoin_transfers_block_number_idx" ON "stablecoin_transfers"("block_number");

-- CreateIndex
CREATE UNIQUE INDEX "stablecoin_transfers_chain_id_token_address_block_number_bl_key" ON "stablecoin_transfers"("chain_id", "token_address", "block_number", "block_time_stamp");

-- CreateIndex
CREATE INDEX "tokens_token_symbol_idx" ON "tokens"("token_symbol");

-- CreateIndex
CREATE UNIQUE INDEX "tokens_chain_id_token_address_key" ON "tokens"("chain_id", "token_address");

-- AddForeignKey
ALTER TABLE "tokens" ADD CONSTRAINT "tokens_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pools" ADD CONSTRAINT "pools_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pools" ADD CONSTRAINT "pools_chain_id_token_0_address_fkey" FOREIGN KEY ("chain_id", "token_0_address") REFERENCES "tokens"("chain_id", "token_address") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pools" ADD CONSTRAINT "pools_chain_id_token_1_address_fkey" FOREIGN KEY ("chain_id", "token_1_address") REFERENCES "tokens"("chain_id", "token_address") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "native_transfers" ADD CONSTRAINT "native_transfers_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cex_flows" ADD CONSTRAINT "cex_flows_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "decoded_events" ADD CONSTRAINT "decoded_events_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_transfers" ADD CONSTRAINT "stablecoin_transfers_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_transfers" ADD CONSTRAINT "stablecoin_transfers_chain_id_token_address_fkey" FOREIGN KEY ("chain_id", "token_address") REFERENCES "tokens"("chain_id", "token_address") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_cex_flows" ADD CONSTRAINT "stablecoin_cex_flows_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stablecoin_cex_flows" ADD CONSTRAINT "stablecoin_cex_flows_chain_id_token_address_fkey" FOREIGN KEY ("chain_id", "token_address") REFERENCES "tokens"("chain_id", "token_address") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_swaps" ADD CONSTRAINT "pool_swaps_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_swaps" ADD CONSTRAINT "pool_swaps_chain_id_pool_address_fkey" FOREIGN KEY ("chain_id", "pool_address") REFERENCES "pools"("chain_id", "pool_address") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_liquidity" ADD CONSTRAINT "pool_liquidity_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_liquidity" ADD CONSTRAINT "pool_liquidity_chain_id_pool_address_fkey" FOREIGN KEY ("chain_id", "pool_address") REFERENCES "pools"("chain_id", "pool_address") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_fees" ADD CONSTRAINT "pool_fees_chain_id_fkey" FOREIGN KEY ("chain_id") REFERENCES "chain_config"("chain_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pool_fees" ADD CONSTRAINT "pool_fees_chain_id_pool_address_fkey" FOREIGN KEY ("chain_id", "pool_address") REFERENCES "pools"("chain_id", "pool_address") ON DELETE RESTRICT ON UPDATE CASCADE;
