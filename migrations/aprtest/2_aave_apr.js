/*
* @title set reserve params
* */

let nodeProvider = require("../../utils/ganache.provider");

const AaveAPR = artifacts.require("AaveAPR");

module.exports = async (deployer,network, accounts) => {
    let [admin,user1,user2] = accounts;

    let _aaveProvider = await nodeProvider.getAave("LendingPoolAddressesProvider");
    let aaveProvider =_aaveProvider.address;

    // https://docs.aave.com/developers/deployed-contracts/deployed-contract-instances

    await deployer.deploy(AaveAPR,aaveProvider);

    let _dai = await nodeProvider.getAave("MockDAI");
    let aaveDai = _dai.address;

    let lenderAPR = await AaveAPR.deployed();
    let tokenApr = await lenderAPR.getAPR(aaveDai);
    console.log("AaveAPR aaveDai", tokenApr.toString());
};
