const { ethers, upgrades } = require("hardhat");

async function main() {
  const proxyAddress = "0xB35277ae23d34FC6cd4CC230C5528db55F8289CB";

  const implAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress);
  console.log("✅ Implementation address:", implAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
