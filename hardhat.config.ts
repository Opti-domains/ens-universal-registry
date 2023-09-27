import dotenv from 'dotenv'
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

// Load environment variables from .env file. Suppress warnings using silent
// if this file is missing. dotenv will never modify any environment variables
// that have already been set.
// https://github.com/motdotla/dotenv
dotenv.config({ debug: false })

const real_accounts = [process.env.DEPLOYER_KEY as string]

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.19",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          }
        }
      },
    ]
  },
  networks: {
    polygon_testnet: {
      url: 'https://polygon-testnet.public.blastapi.io',
      chainId: 80001,
      accounts: real_accounts,
    },
    polygon: {
      url: 'https://polygon-mainnet.public.blastapi.io',
      chainId: 137,
      accounts: real_accounts,
    },
    optimism_goerli: {
      url: `https://goerli.optimism.io`,
      chainId: 420,
      accounts: real_accounts,
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY,
  },
};

export default config;
