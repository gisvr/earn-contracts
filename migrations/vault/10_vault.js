/*
* @title set reserve params
* @author Mint
创建 mVault 记录用户储值
* */

const mController = artifacts.require("mController");;
const mVault = artifacts.require("mVault");

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(LenderAPR);
    let controller = await mController.deployed();

    let compZRX
    if (network == "ropsten") {
        compZRX = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c"
    }
    await deployer.deploy(mVault,controller.address,compZRX,{from:user1});

    let vault = await mVault.deployed();

    await controller.setVault(vault.address,{from:user1});

};
