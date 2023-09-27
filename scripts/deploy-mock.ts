import { ethers } from "hardhat";

async function main() {
  const registry = await ethers.deployContract("ENSRegistry", { gasPrice: 10000000 });
  await registry.waitForDeployment();
  console.log("ENSRegistry", await registry.getAddress());

  const resolver = await ethers.deployContract("ENSMockExternalResolver", [
    await registry.getAddress(),
  ]);
  await resolver.waitForDeployment();
  console.log("ENSMockExternalResolver", await resolver.getAddress());

  const universalResolver = await ethers.deployContract("UniversalResolver", [
    await registry.getAddress(),
    [],
  ]);
  await universalResolver.waitForDeployment();
  console.log("UniversalResolver", await universalResolver.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
