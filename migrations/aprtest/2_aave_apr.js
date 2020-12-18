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
    let aaveDai = _dai.address;
    // let aaveDai = "0x7C728214be9A0049e6a86f2137ec61030D0AA964";
    // let aaveBat = "0x86072CbFF48dA3C1F01824a6761A03F105BCC697";

    let lenderAPR = await AaveAPR.deployed();
    let tokenApr = await lenderAPR.getAPR(aaveDai);
    console.log("AaveAPR aaveDai", tokenApr.toString());
};
