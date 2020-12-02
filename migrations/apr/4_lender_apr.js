/*
* @title set reserve params
* */

const AaveAPR = artifacts.require("AaveAPR");
const CompoundAPR = artifacts.require("CompoundAPR");
const LenderAPR = artifacts.require("LenderAPR");

module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts
    await deployer.deploy(LenderAPR,{from:user1});
    let aaveAPR = await AaveAPR.deployed();
    let compoundAPR = await CompoundAPR.deployed();
    let lenderAPR = await LenderAPR.deployed();


    let aaveDAI,compZRX
    if (network == "ropsten") {
        aaveDAI = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108"; // aave
        compZRX = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c";// comp

    }

    await lenderAPR.addLender("Aave", aaveAPR.address,{from:user1});
    await lenderAPR.addLender("Compound", compoundAPR.address,{from:user1});

    let zeroAddr = "0x0000000000000000000000000000000000000000";
    let foo1 = await lenderAPR.recommend(zeroAddr);
    console.log("lenderAPR",foo1.lender);
    console.log("lenderAPR",foo1.name);
    console.log("lenderAPR",foo1.apr.toString());

    await lenderAPR.removeLender(0,{from:user1});
};
