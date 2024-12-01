import { expect } from "chai";
import { ethers } from "hardhat";
import { ZethereumCore, ZethereumCore__factory } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("ZethereumCore", function () {
  let zethereumCore: ZethereumCore;
  let owner: SignerWithAddress;
  let user: SignerWithAddress;
  let mockVerifier: SignerWithAddress;

  beforeEach(async function () {
    [owner, user, mockVerifier] = await ethers.getSigners();
    
    const ZethereumCore = await ethers.getContractFactory("ZethereumCore");
    zethereumCore = await ZethereumCore.deploy();
    await zethereumCore.waitForDeployment();
    
    await zethereumCore.initialize(mockVerifier.address);
  });

  describe("Initialization", function () {
    it("Should set the verifier address", async function () {
      expect(await zethereumCore.initialize(mockVerifier.address))
        .to.emit(zethereumCore, "Initialized")
        .withArgs(1);
    });

    it("Should revert when initializing with zero address", async function () {
      const ZethereumCore = await ethers.getContractFactory("ZethereumCore");
      const newCore = await ZethereumCore.deploy();
      await expect(newCore.initialize(ethers.ZeroAddress))
        .to.be.revertedWith("ZethereumCore: zero address");
    });

    it("Should revert on double initialization", async function () {
      await expect(zethereumCore.initialize(mockVerifier.address))
        .to.be.revertedWith("Initializable: contract is already initialized");
    });
  });

  describe("Access Control", function () {
    it("Should set the deployer as owner", async function () {
      expect(await zethereumCore.owner()).to.equal(owner.address);
    });

    it("Should allow owner to upgrade", async function () {
      const ZethereumCore = await ethers.getContractFactory("ZethereumCore");
      const newImplementation = await ZethereumCore.deploy();
      
      await expect(zethereumCore.upgradeTo(await newImplementation.getAddress()))
        .to.not.be.reverted;
    });

    it("Should not allow non-owner to upgrade", async function () {
      const ZethereumCore = await ethers.getContractFactory("ZethereumCore");
      const newImplementation = await ZethereumCore.deploy();
      
      await expect(zethereumCore.connect(user).upgradeTo(await newImplementation.getAddress()))
        .to.be.revertedWith("Ownable: caller is not the owner");
    });
  });
});