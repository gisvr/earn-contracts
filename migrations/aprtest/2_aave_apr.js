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
    // let aaveProvider ="0xCfEB869F69431e42cdB54A4F4f105C19C080A601";


    await deployer.deploy(AaveAPR,aaveProvider);

    let _dai = await nodeProvider.getAave("MockDAI");
    let zeroAddr = "0x0000000000000000000000000000000000000000"; 
    let aaveDai = _dai.address; 

    let lenderAPR = await AaveAPR.deployed();
    let tokenApr = await lenderAPR.getAPR(aaveDai);
    ethApr = await lenderAPR.getAPR(zeroAddr);
    console.log("AaveAPR aaveDai %s, aaveEth %s", tokenApr.toString(),ethApr.toString());

   
};
