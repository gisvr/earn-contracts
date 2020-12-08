/*
* @title set reserve params
* */

const mController = artifacts.require("mController");

module.exports = async (deployer) => { 
    await deployer.deploy(mController,user1);
};
