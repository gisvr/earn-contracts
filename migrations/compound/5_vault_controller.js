/*
* @title set reserve params
* */

const mController = artifacts.require("mController");

module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts
    await deployer.deploy(mController,user1,{from:user1});
};
