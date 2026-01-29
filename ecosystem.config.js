module.exports = {
  apps: [
    {
      name: "processors",
      script: "npx",
      args: "tsx src/startProcessors.ts",
      instances: 1,
      autorestart: true,
      watch: false,
      env: {
        NODE_ENV: "prod",
      },
    },

    // Ethereum Worker
    {
      name: "worker-ethereum",
      script: "npx",
      args: "tsx src/index.ts --chain=ethereum --block=24330403 --targetBlock=24330415",
      instances: 1,
      autorestart: true,
      watch: false,
      env: {
        NODE_ENV: "production",
      },
    },

    // Polygon Worker
    {
      name: "worker-polygon",
      script: "npx",
      args: "tsx src/index.ts --chain=polygon --block=0 --targetBlock=999999999",
      instances: 1,
      autorestart: true,
      watch: false,
      env: {
        NODE_ENV: "production",
      },
    },

    // BNB Worker
    {
      name: "worker-bnb",
      script: "npx",
      args: "tsx src/index.ts --chain=bnb --block=0 --targetBlock=999999999",
      instances: 1,
      autorestart: true,
      watch: false,
      env: {
        NODE_ENV: "production",
      },
    },
  ],
};
