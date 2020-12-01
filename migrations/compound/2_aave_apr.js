/*
* @title set reserve params
* */

const AaveAPR = artifacts.require("AaveAPR");

module.exports = async (deployer, network, accounts) => {
    let [ admin,user1,user2] = accounts;
    let aaveProvider =admin

    // https://docs.aave.com/developers/deployed-contracts/deployed-contract-instances
    if (network == "ropsten") {
        aavePrivder = "0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728"
    }
    await deployer.deploy(AaveAPR,aaveProvider,{from:user1});
};
