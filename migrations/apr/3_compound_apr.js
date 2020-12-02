/*
* @title set reserve params
* */

const CompoundAPR = artifacts.require("CompoundAPR");

module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts
    let compComptroller ="0x54188bbedd7b68228fa89cbdda5e3e930459c6c6"
    // https://compound.finance/docs#networks
    if (network == "ropsten") {
        compComptroller = "0x54188bbedd7b68228fa89cbdda5e3e930459c6c6"
    } else if (network == "mainnet") {
        compComptroller = "0x3d9819210a31b4961b30ef54be2aed79b9c9cd3b"
    }

    await deployer.deploy(CompoundAPR, compComptroller,{from:user1});
    let lenderAPR = await CompoundAPR.deployed();

    if (network == "ropsten") {
       await lenderAPR.setETH("0xBe839b6D93E3eA47eFFcCA1F27841C917a8794f3",{from:user1})
    } else if (network == "mainnet") {
        // lenderAPR.setETH("0xBe839b6D93E3eA47eFFcCA1F27841C917a8794f3")
    } else {
       // await lenderAPR.setETH(accounts[0],{from:user1})
    }

    // let compZRX = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c" // comp

    let zeroAddr = "0x0000000000000000000000000000000000000000";
    let tokenApr = await lenderAPR.getAPR(zeroAddr);
    console.log("compoundAPR", tokenApr.toString());
};
