/*
* @title set reserve params
* */

const AaveAPR = artifacts.require("AaveAPR");

module.exports = async (deployer,network, accounts) => {
    let [ admin,user1,user2] = accounts;
    let aaveProvider ="0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728";

    // https://docs.aave.com/developers/deployed-contracts/deployed-contract-instances
    if (network == "ropsten") {
        aaveProvider = "0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728"
    }
    await deployer.deploy(AaveAPR,aaveProvider,{from:user1});

    // let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108";
    let zeroAddr = "0x0000000000000000000000000000000000000000";
    let lenderAPR = await AaveAPR.deployed();
    let tokenApr = await lenderAPR.getAPR(zeroAddr);
    console.log("AaveAPR zeroAddr", tokenApr.toString());
};
