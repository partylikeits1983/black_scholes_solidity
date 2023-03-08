const { expect, assert } = require("chai");
require("@nomiclabs/hardhat-waffle");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

describe("Test math libraries ", () => {

  // input parameters
  let S = "100";
  let K = "100";
  let T = "1";
  let r = "1";
  let sigma = "1";

  S = ethers.utils.parseUnits(S);
  K = ethers.utils.parseUnits(K);
  T = ethers.utils.parseUnits(T);
  r = ethers.utils.parseUnits(r);
  sigma = ethers.utils.parseUnits(sigma);

  // library addresses
  let Statslib;
  let BSlib;

  it("Should deploy libraries", async () => {
    
  signers = await ethers.getSigners();

  const Statistics = await ethers.getContractFactory("Statistics");
  Statslib = await Statistics.deploy();
  await Statslib.deployed();
  console.log("stats library:", Statslib.address);

  // @dev deploy Black Scholes model library
  const BS = await ethers.getContractFactory("BStest", {
    signer: signers[0],
    libraries: {
      Statistics: Statslib.address,
    },
  });
  BSlib = await BS.deploy();
  await BSlib.deployed();
  console.log("BS library:", BSlib.address);
  });

  it("Should calculate D1", async () => {
    let D1 = await BSlib.D1(S,K,r,sigma,T);
    D1 = ethers.BigNumber.from(D1);
    console.log(D1);
  });

  it("Should calculate D2", async () => {
    let D1 = await BSlib.D1(S,K,r,sigma,T);
    let D2 = await BSlib.D2(D1,sigma,T);

    D2 = ethers.BigNumber.from(D2);
    console.log(D2);
  });

  it("Should calculate BS Call", async () => {
    const input = [S, K, T, r, sigma];

    let price_delta = await BSlib.BS_CALL(input);
    let price = ethers.BigNumber.from(price_delta[0]);
    let delta = ethers.BigNumber.from(price_delta[1]);

    console.log(price);
    console.log(delta);
  });

  it("Should calculate price BS Call", async () => {
    const input = [S, K, T, r, sigma];

    let price = await BSlib.c_BS_CALL(input);
    price = ethers.BigNumber.from(price);

    console.log(price);
  });

  it("Should calculate delta BS Call", async () => {
    const input = [S, K, T, r, sigma];

    let delta = await BSlib.delta_BS_CALL(input);
    delta = ethers.BigNumber.from(delta);

    console.log(delta);
  });

  it("Should calculate BS Put", async () => {
    const input = [S, K, T, r, sigma];

    let price_delta = await BSlib.BS_PUT(input);
    let price = ethers.BigNumber.from(price_delta[0]);
    let delta = ethers.BigNumber.from(price_delta[1]);

    console.log(price);
    console.log(delta);
  });

  it("Should calculate price BS Put", async () => {
    const input = [S, K, T, r, sigma];

    let price = await BSlib.c_BS_PUT(input);
    price = ethers.BigNumber.from(price);

    console.log(price);
  });

  it("Should calculate delta BS Call", async () => {
    const input = [S, K, T, r, sigma];

    let delta = await BSlib.delta_BS_PUT(input);
    delta = ethers.BigNumber.from(delta);

    console.log(delta);
  });

});
