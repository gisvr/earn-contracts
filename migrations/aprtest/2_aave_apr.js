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
    if (network == "development") {
        aaveProvider = "0x24E420B42971372F060a93129846761F354Bc50B"
    }
    
    await deployer.deploy(AaveAPR,aaveProvider,{from:user1});

    let aaveDai = "0xA8083d78B6ABC328b4d3B714F76F384eCC7147e1"; 
    let aaveUsdt = "0xB7b9568073C9e745acD84eEb30F1c32F74Ba4946"; 
    
    let lenderAPR = await AaveAPR.deployed();
    let tokenApr = await lenderAPR.getAPR(aaveDai);
    console.log("AaveAPR aaveDai", tokenApr.toString());
};
