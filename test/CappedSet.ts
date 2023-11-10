import { ethers } from "hardhat";
import { expect } from "chai";

async function insert(contract: any, addr: any, value: any) {
  const tx = await contract.insert(addr, value);
  await tx.wait();
  const logs = await ethers.provider.getLogs({ transactionHash: tx.hash });
  const logEvents = logs
  .map(log => contract.interface.parseLog(log))
  .find(log => log.name === "Insert");
  return [logEvents.args[0], logEvents.args[1]]
}

async function getRandomNumber(min: number, max: number) {
  return Math.floor(Math.random() * (max - min) + min);
}


describe("CappedSet contract", function () {
  let cappedSet: any;
  let owner: any;
  let addrs: any;
  let numElements: number = 10;
  before(async function () {

    [owner, ...addrs] = await ethers.getSigners();
    const CappedSet = await ethers.getContractFactory("CappedSet");
    cappedSet = await CappedSet.deploy(numElements);
    await cappedSet.waitForDeployment();
  });

  it("Test insert with max elements", async function () {
    let lowest;
    // insert numElements elements with lowest value will be 4
    await insert(cappedSet, addrs[0].address, 9);
    await insert(cappedSet, addrs[1].address, 4);
    await insert(cappedSet, addrs[2].address, 11);
    await insert(cappedSet, addrs[3].address, 96);
    lowest = await insert(cappedSet, addrs[4].address, 3);
    expect(lowest[0]).to.equal(addrs[4].address);
    expect(lowest[1]).to.equal(3);

    // Insert when it is full
    lowest = await insert(cappedSet, addrs[5].address, 2);
    expect(lowest[0]).to.equal(addrs[5].address);
    expect(lowest[1]).to.equal(2);

  });

  it("Test get Value by address", async function () {
    let value = await cappedSet.getValue(addrs[0].address);
    expect(value).to.equal(9);
  });

  it("Test update Value", async function () {
    await cappedSet.update(addrs[0].address, 10);
    let value = await cappedSet.getValue(addrs[0].address);
    expect(value).to.equal(10);
  });

});