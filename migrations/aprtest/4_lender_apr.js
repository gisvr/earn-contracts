/*
* @title set reserve params
* */

const AaveAPR = artifacts.require("AaveAPR");
const CompoundAPR = artifacts.require("CompoundAPR");
const LenderAPR = artifacts.require("LenderAPR");


module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts
    await deployer.deploy(LenderAPR,{from:user1});
    let aaveAPR = await AaveAPR.deployed();  //
    let lenderAPR = await LenderAPR.deployed(); //  0xB3a1aa50bA2826d55bb53b9367EeD3F444f0e493

    await lenderAPR.addLender("Aave", aaveAPR.address,{from:user1});

    let aaveDai = "0x7C728214be9A0049e6a86f2137ec61030D0AA964";
    let aaveUsdc = "0xA586074FA4Fe3E546A132a16238abe37951D41fE";
    let foo1 = await lenderAPR.recommend(aaveUsdc);
    console.log("lenderAPR",foo1.lender);
    console.log("lenderAPR",foo1.name);
    console.log("lenderAPR",foo1.apr.toString());
};
