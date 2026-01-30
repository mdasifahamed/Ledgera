# BLOCKCHAIN DASHBOARD - COMPLETE AI AGENT IMPLEMENTATION GUIDE

## MISSION STATEMENT
You are an AI agent tasked with building a complete Next.js blockchain analytics dashboard from scratch. Execute each phase sequentially. Create all files with exact code provided. This guide is comprehensive and self-contained.

---

## QUICK START CHECKLIST

- [ ] Phase 1: Initialize Next.js project
- [ ] Phase 2: Install all dependencies  
- [ ] Phase 3: Configure Tailwind & environment
- [ ] Phase 4: Create all type definitions
- [ ] Phase 5: Create all constants
- [ ] Phase 6: Create all utility functions
- [ ] Phase 7: Create all custom hooks
- [ ] Phase 8: Create API integration layer
- [ ] Phase 9: Create React Query hooks
- [ ] Phase 10: Create all UI components
- [ ] Phase 11: Create all chart components
- [ ] Phase 12: Create all layout components
- [ ] Phase 13: Create all section components
- [ ] Phase 14: Create root layout and page
- [ ] Phase 15: Test and verify

---

## CONTINUATION OF SWAP VOLUME SECTION

Continuing from where Step 13.3 was cut off in SwapVolumeSection.tsx:

```typescript
  const handleExport = () => {
    const exportData = selectedPool.timeSeries.map(point => ({
      timestamp: new Date(point.timestamp * 1000).toISOString(),
      volume: point.volume,
      buyVolume: point.buyVolume,
      sellVolume: point.sellVolume,
    }));
    exportToCSV(exportData, 'swap-volume');
  };

  return (
    <section id="swap-volume" className="section-container">
      <h2 className="text-2xl font-bold mb-4">Swap Volume</h2>
      
      {/* Pool Selector Tabs */}
      <div className="flex gap-2 mb-4 overflow-x-auto">
        {data.pools.map((pool, idx) => (
          <button
            key={pool.poolId}
            onClick={() => setSelectedPoolIndex(idx)}
            className={clsx(
              'px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap',
              selectedPoolIndex === idx
                ? 'bg-primary-500 text-white'
                : 'bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700'
            )}
          >
            {pool.tokenPair.join('/')}
          </button>
        ))}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <SummaryCard
          title="Current TVL"
          value={selectedPool.tvl}
          format="currency"
        />
        <SummaryCard
          title="24h Volume"
          value={selectedPool.volume24h}
          format="currency"
        />
        <SummaryCard
          title="Pool"
          value={selectedPool.poolName}
          format="number"
        />
      </div>

      <ChartContainer
        title="Swap Volume Over Time"
        subtitle={`${selectedPool.tokenPair.join('/')} pool`}
        onExport={handleExport}
      >
        <BaseChart option={chartOption} height={400} />
      </ChartContainer>
    </section>
  );
};
```

---

#### STEP 13.4: Liquidity Section

**File: `src/components/sections/LiquiditySection.tsx`**
```typescript
'use client';

import React, { useState } from 'react';
import { useTimeRange } from '@/lib/hooks/useTimeRange';
import { useLiquidity } from '@/lib/api/queries/useLiquidity';
import { SummaryCard } from '@/components/ui/SummaryCard';
import { LoadingSkeleton } from '@/components/ui/LoadingSkeleton';
import { ErrorState } from '@/components/ui/ErrorState';
import { EmptyState } from '@/components/ui/EmptyState';
import { ChartContainer } from '@/components/charts/ChartContainer';
import { BaseChart } from '@/components/charts/BaseChart';
import { getBaseChartOption, getBarChartSeries, getLineChartSeries } from '@/lib/utils/chartHelpers';
import { exportToCSV } from '@/lib/utils/exportData';
import { useTheme } from '@/lib/hooks/useTheme';
import { COLORS } from '@/constants/colors';
import clsx from 'clsx';

export const LiquiditySection: React.FC = () => {
  const { getStartTimestamp, getEndTimestamp } = useTimeRange();
  const { theme } = useTheme();
  const [selectedPoolIndex, setSelectedPoolIndex] = useState(0);

  const { data, isLoading, isError, error, refetch } = useLiquidity({
    poolIds: ['pool1', 'pool2', 'pool3'],
    startTime: getStartTimestamp(),
    endTime: getEndTimestamp(),
  });

  if (isLoading) {
    return (
      <section id="liquidity" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Liquidity Add/Remove</h2>
        <LoadingSkeleton />
      </section>
    );
  }

  if (isError) {
    return (
      <section id="liquidity" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Liquidity Add/Remove</h2>
        <ErrorState error={error as Error} onRetry={refetch} />
      </section>
    );
  }

  if (!data || data.pools.length === 0) {
    return (
      <section id="liquidity" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Liquidity Add/Remove</h2>
        <EmptyState />
      </section>
    );
  }

  const selectedPool = data.pools[selectedPoolIndex];

  // Butterfly chart (mirrored bars)
  const chartOption = {
    ...getBaseChartOption({
      theme,
      yAxisFormatter: (value: number) => `$${Math.abs(value / 1000000).toFixed(2)}M`,
    }),
    series: [
      getBarChartSeries(
        'Added',
        selectedPool.timeSeries.map(point => [point.timestamp * 1000, point.added]),
        COLORS.positive
      ),
      getBarChartSeries(
        'Removed',
        selectedPool.timeSeries.map(point => [point.timestamp * 1000, -point.removed]),
        COLORS.negative
      ),
      getLineChartSeries(
        'Net Liquidity',
        selectedPool.timeSeries.map(point => [point.timestamp * 1000, point.netLiquidity]),
        COLORS.neutral,
        false
      ),
    ],
  };

  const handleExport = () => {
    const exportData = selectedPool.timeSeries.map(point => ({
      timestamp: new Date(point.timestamp * 1000).toISOString(),
      added: point.added,
      removed: point.removed,
      netLiquidity: point.netLiquidity,
    }));
    exportToCSV(exportData, 'liquidity');
  };

  return (
    <section id="liquidity" className="section-container">
      <h2 className="text-2xl font-bold mb-4">Liquidity Add/Remove</h2>
      
      <div className="flex gap-2 mb-4 overflow-x-auto">
        {data.pools.map((pool, idx) => (
          <button
            key={pool.poolId}
            onClick={() => setSelectedPoolIndex(idx)}
            className={clsx(
              'px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap',
              selectedPoolIndex === idx
                ? 'bg-primary-500 text-white'
                : 'bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700'
            )}
          >
            {pool.poolName}
          </button>
        ))}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <SummaryCard
          title="Current TVL"
          value={selectedPool.currentTvl}
          format="currency"
        />
        <SummaryCard
          title="Net Liquidity"
          value={selectedPool.timeSeries[selectedPool.timeSeries.length - 1]?.netLiquidity || 0}
          format="currency"
        />
        <SummaryCard
          title="Top LPs"
          value={selectedPool.topLPs.length}
          format="number"
        />
      </div>

      <ChartContainer
        title="Liquidity Changes Over Time"
        subtitle="Green: Added, Red: Removed"
        onExport={handleExport}
      >
        <BaseChart option={chartOption} height={400} />
      </ChartContainer>

      <div className="mt-6">
        <h3 className="text-lg font-semibold mb-3">Top Liquidity Providers</h3>
        <div className="chart-container">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-border">
                  <th className="text-left p-3">Address</th>
                  <th className="text-right p-3">Added</th>
                  <th className="text-right p-3">Removed</th>
                  <th className="text-right p-3">Net Position</th>
                </tr>
              </thead>
              <tbody>
                {selectedPool.topLPs.map((lp, idx) => (
                  <tr key={idx} className="border-b border-border">
                    <td className="p-3 font-mono text-sm">
                      {lp.address.substring(0, 10)}...{lp.address.substring(lp.address.length - 8)}
                    </td>
                    <td className="text-right p-3 text-positive">
                      ${(lp.addedAmount / 1000000).toFixed(2)}M
                    </td>
                    <td className="text-right p-3 text-negative">
                      ${(lp.removedAmount / 1000000).toFixed(2)}M
                    </td>
                    <td className="text-right p-3">
                      ${(lp.netPosition / 1000000).toFixed(2)}M
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </section>
  );
};
```

---

#### STEP 13.5: Stablecoin Transfer Section

**File: `src/components/sections/StablecoinTransferSection.tsx`**
```typescript
'use client';

import React, { useState } from 'react';
import { useTimeRange } from '@/lib/hooks/useTimeRange';
import { useStablecoinTransfer } from '@/lib/api/queries/useStablecoinTransfer';
import { SummaryCard } from '@/components/ui/SummaryCard';
import { LoadingSkeleton } from '@/components/ui/LoadingSkeleton';
import { ErrorState } from '@/components/ui/ErrorState';
import { EmptyState } from '@/components/ui/EmptyState';
import { ChartContainer } from '@/components/charts/ChartContainer';
import { BaseChart } from '@/components/charts/BaseChart';
import { getBaseChartOption, getLineChartSeries } from '@/lib/utils/chartHelpers';
import { exportToCSV } from '@/lib/utils/exportData';
import { useTheme } from '@/lib/hooks/useTheme';
import { getStablecoinColor } from '@/constants/colors';
import { Button } from '@/components/ui/Button';
import clsx from 'clsx';

export const StablecoinTransferSection: React.FC = () => {
  const { getStartTimestamp, getEndTimestamp } = useTimeRange();
  const { theme } = useTheme();
  const [viewType, setViewType] = useState<'onchain' | 'cex' | 'combined'>('combined');

  const { data, isLoading, isError, error, refetch } = useStablecoinTransfer({
    startTime: getStartTimestamp(),
    endTime: getEndTimestamp(),
    viewType,
  });

  if (isLoading) {
    return (
      <section id="stablecoin-transfer" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Stablecoin Transfers</h2>
        <LoadingSkeleton />
      </section>
    );
  }

  if (isError) {
    return (
      <section id="stablecoin-transfer" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Stablecoin Transfers</h2>
        <ErrorState error={error as Error} onRetry={refetch} />
      </section>
    );
  }

  if (!data || data.coins.length === 0) {
    return (
      <section id="stablecoin-transfer" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Stablecoin Transfers</h2>
        <EmptyState />
      </section>
    );
  }

  const chartOption = {
    ...getBaseChartOption({
      theme,
      yAxisFormatter: (value: number) => `$${(value / 1000000).toFixed(2)}M`,
    }),
    series: data.coins.map(coin =>
      getLineChartSeries(
        coin.coin,
        coin.timeSeries.map(point => [point.timestamp * 1000, point.value]),
        getStablecoinColor(coin.coin),
        true
      )
    ),
  };

  // Pie chart for market distribution
  const pieChartOption = {
    backgroundColor: 'transparent',
    tooltip: {
      trigger: 'item' as const,
      formatter: '{b}: {c}% ({d}%)',
    },
    legend: {
      bottom: 10,
      textStyle: {
        color: theme === 'dark' ? '#f1f5f9' : '#0f172a',
      },
    },
    series: [
      {
        type: 'pie' as const,
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: theme === 'dark' ? '#1e293b' : '#ffffff',
          borderWidth: 2,
        },
        label: {
          show: true,
          formatter: '{b}: {c}%',
          color: theme === 'dark' ? '#f1f5f9' : '#0f172a',
        },
        data: data.marketDistribution.map(item => ({
          name: item.coin,
          value: item.marketShare,
          itemStyle: {
            color: getStablecoinColor(item.coin),
          },
        })),
      },
    ],
  };

  const handleExport = () => {
    const exportData = data.coins.flatMap(coin =>
      coin.timeSeries.map(point => ({
        timestamp: new Date(point.timestamp * 1000).toISOString(),
        coin: coin.coin,
        value: point.value,
      }))
    );
    exportToCSV(exportData, 'stablecoin-transfers');
  };

  return (
    <section id="stablecoin-transfer" className="section-container">
      <h2 className="text-2xl font-bold mb-4">Stablecoin Transfers</h2>
      
      {/* View Toggle */}
      <div className="flex gap-2 mb-4">
        {(['onchain', 'cex', 'combined'] as const).map(type => (
          <Button
            key={type}
            variant={viewType === type ? 'primary' : 'secondary'}
            size="sm"
            onClick={() => setViewType(type)}
          >
            {type === 'onchain' ? 'On-Chain' : type === 'cex' ? 'CEX' : 'Combined'}
          </Button>
        ))}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
        {/* Market Distribution Pie Chart */}
        <div className="chart-container">
          <h3 className="text-lg font-semibold mb-3">Market Distribution</h3>
          <BaseChart option={pieChartOption} height={300} />
        </div>

        {/* Summary Cards */}
        <div className="space-y-4">
          {data.coins.slice(0, 3).map(coin => (
            <SummaryCard
              key={coin.coin}
              title={`${coin.coin} 24h Volume`}
              value={coin.onChainVolume24h}
              format="currency"
            />
          ))}
        </div>
      </div>

      <ChartContainer
        title="Transfer Volume Over Time"
        subtitle="Stablecoin transfers by coin"
        onExport={handleExport}
      >
        <BaseChart option={chartOption} height={400} />
      </ChartContainer>
    </section>
  );
};
```

---

#### STEP 13.6: Stablecoin Metrics Section

**File: `src/components/sections/StablecoinMetricsSection.tsx`**
```typescript
'use client';

import React from 'react';
import { useTimeRange } from '@/lib/hooks/useTimeRange';
import { useStablecoinMetrics } from '@/lib/api/queries/useStablecoinMetrics';
import { LoadingSkeleton } from '@/components/ui/LoadingSkeleton';
import { ErrorState } from '@/components/ui/ErrorState';
import { EmptyState } from '@/components/ui/EmptyState';
import { ChartContainer } from '@/components/charts/ChartContainer';
import { BaseChart } from '@/components/charts/BaseChart';
import { getBaseChartOption, getLineChartSeries } from '@/lib/utils/chartHelpers';
import { exportToCSV } from '@/lib/utils/exportData';
import { useTheme } from '@/lib/hooks/useTheme';
import { getStablecoinColor } from '@/constants/colors';

export const StablecoinMetricsSection: React.FC = () => {
  const { getStartTimestamp, getEndTimestamp } = useTimeRange();
  const { theme } = useTheme();

  const { data, isLoading, isError, error, refetch } = useStablecoinMetrics({
    startTime: getStartTimestamp(),
    endTime: getEndTimestamp(),
  });

  if (isLoading) {
    return (
      <section id="stablecoin-metrics" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Stablecoin Metrics</h2>
        <LoadingSkeleton />
      </section>
    );
  }

  if (isError) {
    return (
      <section id="stablecoin-metrics" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Stablecoin Metrics</h2>
        <ErrorState error={error as Error} onRetry={refetch} />
      </section>
    );
  }

  if (!data || data.metrics.length === 0) {
    return (
      <section id="stablecoin-metrics" className="section-container">
        <h2 className="text-2xl font-bold mb-4">Stablecoin Metrics</h2>
        <EmptyState />
      </section>
    );
  }

  // Market Cap Chart
  const marketCapOption = {
    ...getBaseChartOption({
      theme,
      yAxisFormatter: (value: number) => `$${(value / 1000000000).toFixed(2)}B`,
    }),
    series: data.metrics.map(metric =>
      getLineChartSeries(
        metric.coin,
        metric.marketCap.map(point => [point.timestamp * 1000, point.value]),
        getStablecoinColor(metric.coin),
        true
      )
    ),
  };

  // Peg Deviation Chart
  const pegDeviationOption = {
    ...getBaseChartOption({
      theme,
      yAxisFormatter: (value: number) => `${(value * 100).toFixed(3)}%`,
    }),
    series: data.metrics.map(metric =>
      getLineChartSeries(
        metric.coin,
        metric.pegDeviation.map(point => [point.timestamp * 1000, point.value]),
        getStablecoinColor(metric.coin),
        false
      )
    ),
  };

  // Transfer Volume Chart
  const transferVolumeOption = {
    ...getBaseChartOption({
      theme,
      yAxisFormatter: (value: number) => `$${(value / 1000000000).toFixed(2)}B`,
    }),
    series: data.metrics.map(metric =>
      getLineChartSeries(
        metric.coin,
        metric.transferVolume.map(point => [point.timestamp * 1000, point.value]),
        getStablecoinColor(metric.coin),
        true
      )
    ),
  };

  // Active Addresses Chart
  const activeAddressesOption = {
    ...getBaseChartOption({
      theme,
      yAxisFormatter: (value: number) => `${(value / 1000).toFixed(1)}K`,
    }),
    series: data.metrics.map(metric =>
      getLineChartSeries(
        metric.coin,
        metric.activeAddresses.map(point => [point.timestamp * 1000, point.value]),
        getStablecoinColor(metric.coin),
        false
      )
    ),
  };

  const handleExport = (metricName: string, metricData: any) => {
    exportToCSV(metricData, `stablecoin-${metricName}`);
  };

  return (
    <section id="stablecoin-metrics" className="section-container">
      <h2 className="text-2xl font-bold mb-6">Stablecoin Metrics Dashboard</h2>
      
      {/* Grid Layout for Multiple Metrics */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Market Cap */}
        <ChartContainer
          title="Market Cap"
          subtitle="Total market capitalization"
          onExport={() => handleExport('market-cap', data.metrics.flatMap(m => 
            m.marketCap.map(p => ({ timestamp: new Date(p.timestamp * 1000).toISOString(), coin: m.coin, value: p.value }))
          ))}
        >
          <BaseChart option={marketCapOption} height={300} />
        </ChartContainer>

        {/* Peg Deviation */}
        <ChartContainer
          title="Peg Deviation from $1.00"
          subtitle="Deviation percentage from dollar peg"
          onExport={() => handleExport('peg-deviation', data.metrics.flatMap(m => 
            m.pegDeviation.map(p => ({ timestamp: new Date(p.timestamp * 1000).toISOString(), coin: m.coin, deviation: p.value }))
          ))}
        >
          <BaseChart option={pegDeviationOption} height={300} />
        </ChartContainer>

        {/* Transfer Volume */}
        <ChartContainer
          title="Transfer Volume"
          subtitle="On-chain transfer volume"
          onExport={() => handleExport('transfer-volume', data.metrics.flatMap(m => 
            m.transferVolume.map(p => ({ timestamp: new Date(p.timestamp * 1000).toISOString(), coin: m.coin, volume: p.value }))
          ))}
        >
          <BaseChart option={transferVolumeOption} height={300} />
        </ChartContainer>

        {/* Active Addresses */}
        <ChartContainer
          title="Active Addresses"
          subtitle="Unique addresses making transactions"
          onExport={() => handleExport('active-addresses', data.metrics.flatMap(m => 
            m.activeAddresses.map(p => ({ timestamp: new Date(p.timestamp * 1000).toISOString(), coin: m.coin, addresses: p.value }))
          ))}
        >
          <BaseChart option={activeAddressesOption} height={300} />
        </ChartContainer>
      </div>

      {/* Velocity Metrics Table */}
      <div className="mt-6">
        <h3 className="text-lg font-semibold mb-3">Velocity Metrics</h3>
        <div className="chart-container">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-border">
                  <th className="text-left p-3">Coin</th>
                  <th className="text-right p-3">Velocity</th>
                  <th className="text-right p-3">Interpretation</th>
                </tr>
              </thead>
              <tbody>
                {data.metrics.map((metric) => (
                  <tr key={metric.coin} className="border-b border-border">
                    <td className="p-3 font-semibold">{metric.coin}</td>
                    <td className="text-right p-3">{metric.velocity.toFixed(2)}</td>
                    <td className="text-right p-3 text-sm text-muted-foreground">
                      {metric.velocity > 2 ? 'High turnover' : metric.velocity > 1 ? 'Moderate' : 'Low turnover'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </section>
  );
};
```

---

### PHASE 14: ROOT APPLICATION SETUP

#### STEP 14.1: Root Layout with Providers

**File: `src/app/layout.tsx`**
```typescript
import './globals.css';
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import { Providers } from './providers';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Blockchain Analytics Dashboard',
  description: 'Real-time blockchain metrics and analytics dashboard',
  keywords: ['blockchain', 'analytics', 'cryptocurrency', 'metrics', 'dashboard'],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

#### STEP 14.2: Providers Component

**File: `src/app/providers.tsx`**
```typescript
'use client';

import React from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30000,
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
```

#### STEP 14.3: Main Dashboard Page

**File: `src/app/page.tsx`**
```typescript
'use client';

import { MainLayout } from '@/components/layout/MainLayout';
import { NativeCurrencySection } from '@/components/sections/NativeCurrencySection';
import { CexFlowSection } from '@/components/sections/CexFlowSection';
import { SwapVolumeSection } from '@/components/sections/SwapVolumeSection';
import { LiquiditySection } from '@/components/sections/LiquiditySection';
import { StablecoinTransferSection } from '@/components/sections/StablecoinTransferSection';
import { StablecoinMetricsSection } from '@/components/sections/StablecoinMetricsSection';

export default function DashboardPage() {
  return (
    <MainLayout>
      <div className="space-y-8">
        <NativeCurrencySection />
        <CexFlowSection />
        <SwapVolumeSection />
        <LiquiditySection />
        <StablecoinTransferSection />
        <StablecoinMetricsSection />
      </div>
    </MainLayout>
  );
}
```

---

### PHASE 15: FINAL SETUP & TESTING

#### STEP 15.1: Create README

**File: `README.md`**
```markdown
# Blockchain Analytics Dashboard

A comprehensive Next.js dashboard for blockchain metrics and analytics.

## Features

- 📊 Native currency transfer tracking
- 💱 CEX inflow/outflow analysis
- 🔄 Swap volume monitoring
- 💧 Liquidity tracking
- 💵 Stablecoin analytics
- 🌓 Dark/Light theme
- 📱 Responsive design
- 📊 Interactive ECharts visualizations

## Tech Stack

- Next.js 14+
- TypeScript
- Tailwind CSS
- Apache ECharts
- TanStack Query (React Query)
- Axios

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn

### Installation

1. Clone the repository
```bash
git clone <your-repo>
cd blockchain-dashboard
```

2. Install dependencies
```bash
npm install
```

3. Configure environment variables
```bash
cp .env.example .env.local
```

Edit `.env.local`:
```env
NEXT_PUBLIC_API_BASE_URL=https://your-api-url.com/api
NEXT_PUBLIC_ENABLE_MOCK_DATA=false
```

4. Run development server
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

### Building for Production

```bash
npm run build
npm start
```

## Project Structure

```
src/
├── app/              # Next.js app router pages
├── components/       # React components
│   ├── charts/      # Chart components
│   ├── common/      # Shared components
│   ├── layout/      # Layout components
│   ├── sections/    # Dashboard sections
│   └── ui/          # UI primitives
├── lib/
│   ├── api/         # API integration
│   ├── hooks/       # Custom hooks
│   └── utils/       # Utility functions
├── types/           # TypeScript types
└── constants/       # App constants
```

## API Integration

### Using Mock Data

Set in `.env.local`:
```env
NEXT_PUBLIC_ENABLE_MOCK_DATA=true
```

### Connecting Your API

1. Update `.env.local` with your API URL
2. Set `NEXT_PUBLIC_ENABLE_MOCK_DATA=false`
3. Modify query hooks in `src/lib/api/queries/` to match your API response format

Example for Native Currency:

```typescript
// src/lib/api/queries/useNativeCurrency.ts
export const useNativeCurrency = (params: UseNativeCurrencyParams) => {
  return useQuery({
    queryKey: ['native-currency', params],
    queryFn: async () => {
      const response = await apiClient.get<NativeCurrencyResponse>(
        `${API_ENDPOINTS.NATIVE_CURRENCY}?${buildQueryParams(params)}`
      );
      return response.data;
    },
  });
};
```

### API Endpoints

Configure in `src/lib/api/endpoints.ts`:

- `/native-currency` - Native currency transfers
- `/cex-flow` - CEX inflow/outflow
- `/swap-volume` - Swap volumes
- `/liquidity` - Liquidity changes
- `/stablecoin-transfer` - Stablecoin transfers
- `/stablecoin-metrics` - Stablecoin metrics

### Expected API Response Format

See `src/types/api.ts` for complete type definitions.

## Customization

### Adding New Chains

Edit `src/constants/chains.ts`:

```typescript
export const CHAINS: ChainConfig[] = [
  {
    id: 'NEW',
    name: 'New Chain',
    color: '#hexcode',
    icon: '🔷',
  },
  // ... existing chains
];
```

### Adding New Time Ranges

Edit `src/constants/timeRanges.ts`

### Customizing Colors

Edit `src/constants/colors.ts`

## Development

### Running Tests

```bash
npm run test
```

### Linting

```bash
npm run lint
```

### Type Checking

```bash
npx tsc --noEmit
```

## License

MIT

## Support

For issues and questions, please open a GitHub issue.
```

---

#### STEP 15.2: Run the Development Server

Execute these commands in sequence:

```bash
# Navigate to project
cd blockchain-dashboard

# Install dependencies (if not done)
npm install

# Start development server
npm run dev
```

Expected output:
```
> blockchain-dashboard@1.0.0 dev
> next dev

  ▲ Next.js 14.2.0
  - Local:        http://localhost:3000

 ✓ Ready in 2.3s
```

#### STEP 15.3: Verify Installation

Open browser to `http://localhost:3000`

Expected result:
- Dashboard loads with dark theme
- All 6 sections visible
- Mock data displays in charts
- No console errors
- Time range selector works
- Chain selector toggles work
- Theme toggle works
- Charts are interactive (zoom, pan, hover)

---

## API INTEGRATION GUIDE

### Where to Plug In Your APIs

All API integration points are in `src/lib/api/queries/`. Each file has this structure:

```typescript
export const useMetricName = (params: Params) => {
  return useQuery({
    queryKey: ['metric-name', params],
    queryFn: async () => {
      // THIS IS WHERE YOU PLUG IN YOUR API
      if (isMockEnabled()) {
        // Mock data (delete this)
        return generateMockData(...);
      }

      // YOUR ACTUAL API CALL
      const response = await apiClient.get<ResponseType>(
        `${API_ENDPOINTS.YOUR_ENDPOINT}?${buildQueryParams(params)}`
      );

      return response.data;
    },
  });
};
```

### Step-by-Step API Integration

1. **Update Environment**
```env
NEXT_PUBLIC_API_BASE_URL=https://your-api.com/api
NEXT_PUBLIC_ENABLE_MOCK_DATA=false
```

2. **Update Endpoints** (`src/lib/api/endpoints.ts`)
```typescript
export const API_ENDPOINTS = {
  NATIVE_CURRENCY: '/your-actual-endpoint',
  // ... update others
};
```

3. **Transform API Response** (if needed)

If your API returns different format:

```typescript
// Add transformer function
const transformApiResponse = (apiData: YourApiType): ExpectedType => {
  return {
    // Map your API response to expected format
    chains: apiData.yourData.map(item => ({
      chain: item.blockchain,
      // ... map other fields
    })),
  };
};

// Use in queryFn
queryFn: async () => {
  const response = await apiClient.get(...);
  return transformApiResponse(response.data);
}
```

4. **Test Each Endpoint**

Use React Query Devtools (visible in dev mode):
- Click Devtools at bottom of page
- See all queries and their states
- Inspect response data
- Check for errors

---

## TROUBLESHOOTING

### Common Issues and Solutions

**Issue: "Module not found: Can't resolve '@/...'"**
Solution: Check `tsconfig.json` has correct paths configuration

**Issue: Charts not rendering**
Solution: 
- Verify echarts packages installed
- Check browser console for errors
- Ensure data format matches expected types

**Issue: "window is not defined"**
Solution: Add `'use client'` directive at top of component files

**Issue: Hydration errors**
Solution: Ensure theme hook checks `mounted` state before rendering

**Issue: API calls failing**
Solution:
- Check CORS settings on your API
- Verify API_BASE_URL in .env.local
- Check Network tab in browser DevTools
- Verify response format matches TypeScript types

**Issue: React Query infinite loading**
Solution:
- Check queryFn returns data
- Verify API endpoint is reachable
- Check for JavaScript errors in queryFn

---

## COMPLETION CHECKLIST

Verify all files are created:

### Types (3 files)
- [ ] `src/types/common.ts`
- [ ] `src/types/api.ts`
- [ ] `src/types/chart.ts`

### Constants (3 files)
- [ ] `src/constants/chains.ts`
- [ ] `src/constants/timeRanges.ts`
- [ ] `src/constants/colors.ts`

### Utils (4 files)
- [ ] `src/lib/utils/formatters.ts`
- [ ] `src/lib/utils/chartHelpers.ts`
- [ ] `src/lib/utils/exportData.ts`

### Hooks (4 files)
- [ ] `src/lib/hooks/useTimeRange.ts`
- [ ] `src/lib/hooks/useChainFilter.ts`
- [ ] `src/lib/hooks/useTheme.ts`
- [ ] `src/lib/hooks/useMediaQuery.ts`

### API Layer (8 files)
- [ ] `src/lib/api/client.ts`
- [ ] `src/lib/api/endpoints.ts`
- [ ] `src/lib/api/queries/useNativeCurrency.ts`
- [ ] `src/lib/api/queries/useCexFlow.ts`
- [ ] `src/lib/api/queries/useSwapVolume.ts`
- [ ] `src/lib/api/queries/useLiquidity.ts`
- [ ] `src/lib/api/queries/useStablecoinTransfer.ts`
- [ ] `src/lib/api/queries/useStablecoinMetrics.ts`

### UI Components (8 files)
- [ ] `src/components/ui/Button.tsx`
- [ ] `src/components/ui/Card.tsx`
- [ ] `src/components/ui/SummaryCard.tsx`
- [ ] `src/components/ui/LoadingSkeleton.tsx`
- [ ] `src/components/ui/EmptyState.tsx`
- [ ] `src/components/ui/ErrorState.tsx`
- [ ] `src/components/ui/Select.tsx`

### Chart Components (2 files)
- [ ] `src/components/charts/BaseChart.tsx`
- [ ] `src/components/charts/ChartContainer.tsx`

### Common Components (2 files)
- [ ] `src/components/common/ChainSelector.tsx`
- [ ] `src/components/common/ExportButton.tsx`

### Layout Components (4 files)
- [ ] `src/components/layout/Header.tsx`
- [ ] `src/components/layout/Sidebar.tsx`
- [ ] `src/components/layout/TimeRangeBar.tsx`
- [ ] `src/components/layout/MainLayout.tsx`

### Section Components (6 files)
- [ ] `src/components/sections/NativeCurrencySection.tsx`
- [ ] `src/components/sections/CexFlowSection.tsx`
- [ ] `src/components/sections/SwapVolumeSection.tsx`
- [ ] `src/components/sections/LiquiditySection.tsx`
- [ ] `src/components/sections/StablecoinTransferSection.tsx`
- [ ] `src/components/sections/StablecoinMetricsSection.tsx`

### App Files (4 files)
- [ ] `src/app/layout.tsx`
- [ ] `src/app/providers.tsx`
- [ ] `src/app/page.tsx`
- [ ] `src/app/globals.css`

### Config Files (5 files)
- [ ] `tailwind.config.ts`
- [ ] `next.config.js`
- [ ] `tsconfig.json`
- [ ] `.env.local`
- [ ] `.env.example`

### Documentation (1 file)
- [ ] `README.md`

**Total Files: 59**

---

## FINAL EXECUTION COMMAND SEQUENCE

Execute these commands in exact order:

```bash
# 1. Create project
npx create-next-app@14 blockchain-dashboard --typescript --tailwind --app --yes
cd blockchain-dashboard

# 2. Install dependencies
npm install echarts@5.5.0 echarts-for-react@3.0.2
npm install @tanstack/react-query@5.28.0 @tanstack/react-query-devtools@5.28.0
npm install axios@1.6.7
npm install date-fns@3.3.1
npm install lucide-react@0.263.1
npm install clsx@2.1.0

# 3. Create all files (follow guide above to create each file)

# 4. Run development server
npm run dev
```

---

## SUCCESS CRITERIA

Dashboard is complete when:

✅ All 59 files created
✅ No TypeScript errors
✅ No build errors
✅ Development server runs on localhost:3000
✅ All 6 sections render
✅ Mock data displays in charts
✅ Time range selector works
✅ Chain filter works
✅ Theme toggle works
✅ All charts interactive (zoom, hover, export)
✅ Sidebar navigation scrolls to sections
✅ Responsive on mobile/tablet/desktop
✅ React Query Devtools accessible

---

## POST-IMPLEMENTATION

After successful build:

1. **Test with Mock Data**
   - Verify all sections load
   - Test all interactions
   - Check responsive behavior

2. **Integrate Your API**
   - Update environment variables
   - Modify query hooks
   - Test with real data

3. **Customize**
   - Add your branding
   - Adjust colors
   - Add new features

4. **Deploy**
   - Build for production: `npm run build`
   - Deploy to Vercel, Netlify, or your platform

---

## SUPPORT & RESOURCES

- Next.js Docs: https://nextjs.org/docs
- ECharts Docs: https://echarts.apache.org/en/index.html
- TanStack Query: https://tanstack.com/query/latest
- Tailwind CSS: https://tailwindcss.com/docs

---

END OF IMPLEMENTATION GUIDE
