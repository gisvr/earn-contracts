/*
* @title set reserve params 
* */

const AaveAPR = artifacts.require("AaveAPR");
const CompoundAPR = artifacts.require("CompoundAPR");
const LenderAPR = artifacts.require("LenderAPR");

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(LenderAPR);
    let aaveAPR = await AaveAPR.deployed();
    let compoundAPR = await CompoundAPR.deployed();
    let lenderAPR = await LenderAPR.deployed();


    let aaveDAI,compZRX
    if (network == "ropsten") {
        aaveDAI = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A" // aave
        compZRX = "0x00e02a5200ce3d5b5743f5369deb897946c88121" // comp
    } 
     
    // await lenderAPR.addLender("Aave", aaveAPR.address);
    await lenderAPR.addLender("Compound", compoundAPR.address);

    let foo1 = await lenderAPR.recommend(compZRX)
    console.log("lenderAPR",lenderAPR.address, foo1)
};
