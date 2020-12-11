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
        aaveProvider = "0xCfEB869F69431e42cdB54A4F4f105C19C080A601"
    }

    await deployer.deploy(AaveAPR,aaveProvider,{from:user1});

    //  '0x7C728214be9A0049e6a86f2137ec61030D0AA964',
    //   '0x86072CbFF48dA3C1F01824a6761A03F105BCC697',
    //   '0xA586074FA4Fe3E546A132a16238abe37951D41fE',
    //   '0x970e8f18ebfEa0B08810f33a5A40438b9530FBCF'
    let aaveDai = "0x7C728214be9A0049e6a86f2137ec61030D0AA964";
    let aaveBat = "0x86072CbFF48dA3C1F01824a6761A03F105BCC697";

    let lenderAPR = await AaveAPR.deployed();
    let tokenApr = await lenderAPR.getAPR(aaveDai);
    console.log("AaveAPR aaveDai", tokenApr.toString());
};
