/*
* @title set reserve params
* */

const EarnController = artifacts.require("EarnController"); 

module.exports = async(deployer, network, accounts)  => {
    let [ower, user1] = accounts 
    await deployer.deploy(EarnController,ower,user1);

    // let controller = await mController.deployed();
    // await vault.setController(controller.address)
};
