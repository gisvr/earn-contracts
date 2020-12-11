/*
* @title set reserve params
* */

const mController = artifacts.require("mController");
const mVault = artifacts.require("mVault");

module.exports = async(deployer, network, accounts)  => {
    let [ower, user1] = accounts
    await deployer.deploy(mVault);
    let vault = await mVault.deployed();

    await deployer.deploy(mController,vault.address);

    let controller = await mController.deployed();
    await vault.setController(controller.address)
};
