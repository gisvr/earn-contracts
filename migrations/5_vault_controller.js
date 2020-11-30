/*
* @title set reserve params 
* */

const mController = artifacts.require("mController");

module.exports = async (deployer, network, accounts) => { 
    let [ower, _rewards] = accounts 
    await deployer.deploy(mController,[_rewards]);
};
