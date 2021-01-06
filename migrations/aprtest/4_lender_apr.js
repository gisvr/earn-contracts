/*
* @title set reserve params
* */
let nodeProvider = require("../../utils/ganache.provider");
const AaveAPR = artifacts.require("AaveAPR");
const CompoundAPR = artifacts.require("CompoundAPR");
const LenderAPR = artifacts.require("LenderAPR");


module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts
    await deployer.deploy(LenderAPR);
    let aaveAPR = await AaveAPR.deployed();  //
    let lenderAPR = await LenderAPR.deployed(); //  

    await lenderAPR.addLender("Aave", aaveAPR.address);

    let _dai = await nodeProvider.getAave("MockDAI");
    let aaveDai = _dai.address;
    let foo1 = await lenderAPR.recommend(aaveDai);
    console.log("lenderAPR",foo1.lender);
    console.log("lenderAPR",foo1.name);
    console.log("lenderAPR",foo1.apr.toString());
};
