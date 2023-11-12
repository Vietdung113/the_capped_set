import { ethers } from "hardhat";

async function main() {
  const numElements = 10;
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);


  const cappedSet = await ethers.deployContract("CappedSet", [numElements]);

  await cappedSet.waitForDeployment();

  console.log(
    "deployed CappedSet to:", await cappedSet.getAddress()
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
