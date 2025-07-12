require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");
require("@nomicfoundation/hardhat-verify");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    arbitrumMainnet: {
      url: process.env.ARBITRUM_MAINNET_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
    // otras redes si las tienes
  },
  etherscan: {
    apiKey: {
      arbitrumOne: process.env.ARBISCAN_API_KEY,
    },
  },
};
