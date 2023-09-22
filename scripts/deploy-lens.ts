import { ethers, network } from "hardhat";

const LENS_HUB_ADDRESS: {[chainId: number]: string} = {
  80001: "0x60Ae865ee4C725cd04353b5AAb364553f56ceF82",
  137: "0xDb46d1Dc155634FbC732f92E853b10B288AD5a1d",
}

async function main() {
  const chainId = network.config.chainId;

  console.log(chainId);

  const registry = await ethers.deployContract("ENSRegistry");
  await registry.waitForDeployment();
  console.log("ENSRegistry", await registry.getAddress());

  const resolver = await ethers.deployContract("ENSLensResolver", [
    await registry.getAddress(),
    LENS_HUB_ADDRESS[chainId!],
  ]);
  await resolver.waitForDeployment();
  console.log("ENSLensResolver", await resolver.getAddress());

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
