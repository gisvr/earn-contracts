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
        aaveDAI = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A" // aave
        compZRX = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c" // comp

    }

    // await lenderAPR.addLender("Aave", aaveAPR.address);
    await lenderAPR.addLender("Compound", compoundAPR.address,{from:user1});

    // let foo1 = await lenderAPR.recommend(compZRX,{from,user1})
    // console.log("lenderAPR",lenderAPR.address, foo1)
};
