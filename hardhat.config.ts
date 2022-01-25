import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

import { HardhatUserConfig } from "hardhat/types";

import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-etherscan";
import "solidity-coverage";

const PRIVATE_KEY = process.env.KEY || "";
const INFURA_API_KEY = process.env.INFURA || "";
const ETHERSCAN_API_KEY = process.env.ETH || "";

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: {
    compilers: [
      { version: '0.5.1', settings: {} },
      { version: '0.6.0', settings: {} },
      { version: '0.6.6', settings: {} },
      { version: '0.6.8', settings: {} },
      { version: '0.6.12', settings: {} },
      { version: '0.7.6', settings: {} },
      {
        version: '0.8.0', settings: {
          optimizer: {
            enabled: true
          },
        },
      },
      {
        version: '0.8.3', settings: {
          optimizer: {
            enabled: true
          },
        },
      },
      {
        version: '0.8.4', settings: {
          optimizer: {
            enabled: true
          },
        },
      },
      {
        version: '0.8.9', settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
    ],
  },
  networks: {
    hardhat: {},
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
    coverage: {
      url: "http://127.0.0.1:8555", // Coverage launches its own ganache-cli client
    },
    fooking: {
      url: "https://speedy-nodes-nyc.moralis.io/2b3d187d1e37fe5084871be7/bsc/mainnet",
      accounts: [PRIVATE_KEY]
    },
    metisTestnet: {
      url: "https://stardust.metis.io/?owner=588",
      accounts: [PRIVATE_KEY]
    },
    metisMainnet: {
      url: "https://andromeda.metis.io/?owner=1088",
      accounts: [PRIVATE_KEY]
    },
    bsc97: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: [PRIVATE_KEY]
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY,
  },
};

export default config;
