/*
* @title set reserve params
* @author Mint
创建 mVault 记录用户储值
* */

const mController = artifacts.require("mController");;
const mVault = artifacts.require("mVault");

module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts;
    let controller = await mController.deployed();


    let compZRX = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c" // underlyin

    console.log("controller",controller.address);
    await deployer.deploy(mVault,controller.address,compZRX,{from:user1});

    let vault = await mVault.deployed();

    //0x04215e67Ce17D131386F59976A32751de5072D3c
    console.log("vault",vault.address);
    await controller.setVault(compZRX,vault.address,{from:user1});

};
