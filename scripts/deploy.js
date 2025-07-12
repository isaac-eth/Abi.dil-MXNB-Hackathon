const { ethers, upgrades } = require("hardhat");

async function main() {
  const Escrow = await ethers.getContractFactory("EscrowUpgradeable");

  const escrow = await upgrades.deployProxy(Escrow, [], {
    initializer: "initialize",
  });

  await escrow.waitForDeployment();
  console.log("✅ Escrow deployed to:", await escrow.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
