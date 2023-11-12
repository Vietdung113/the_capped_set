import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from 'dotenv'
dotenv.config()

const ENPOINT = "https://sepolia.infura.io/v3/c7f0f01d450a4462957eb6de371ab061"

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY || '',
  },
  networks: {
    sepolia: {
      url: ENPOINT,
      accounts: [process.env.PRIVATE_KEY || ''],
    }
  }
};



export default config;
