/*
* @title set reserve params
* @author Mint
创建 mVault 记录用户储值
* */

const mController = artifacts.require("mController");
const LenderAPR = artifacts.require("LenderAPR");
const mVault = artifacts.require("mVault");

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(LenderAPR);
    let controller = await mController.deployed();

    let reserveDAI
    if (network == "ropsten") {
        reserveDAI = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A"
    }

    await deployer.deploy(mVault,[controller.address,reserveDAI]);
    
};