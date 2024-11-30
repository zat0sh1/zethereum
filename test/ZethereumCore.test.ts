import { expect } from "chai";
import { ethers } from "hardhat";
import { ZethereumCore } from "../typechain-types";

describe("ZethereumCore", function () {
  let zethereumCore: ZethereumCore;

  beforeEach(async function () {
    const ZethereumCore = await ethers.getContractFactory("ZethereumCore");
    zethereumCore = await ZethereumCore.deploy();
    await zethereumCore.waitForDeployment();
  });

  it("Should be initialized after deployment", async function () {
    expect(await zethereumCore.isInitialized()).to.be.true;
  });

  it("Should return correct status", async function () {
    expect(await zethereumCore.getStatus()).to.equal(await zethereumCore.isInitialized());
  });
});