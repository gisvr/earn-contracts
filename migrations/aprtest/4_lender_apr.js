/*
* @title set reserve params
* */

const AaveAPR = artifacts.require("AaveAPR");
const CompoundAPR = artifacts.require("CompoundAPR");
const LenderAPR = artifacts.require("LenderAPR");


module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts
    await deployer.deploy(LenderAPR,{from:user1});
    let aaveAPR = await AaveAPR.deployed();  //0x9a16Bf8B4a0B83a8e9c6126c5595Ad81f772c5F8
    let lenderAPR = await LenderAPR.deployed(); // 0xaF27479F1682d323Af2a030a9bBdCf7c8EA8Ca21
 
    await lenderAPR.addLender("Aave", aaveAPR.address,{from:user1}); 

    let aaveDai = "0xA8083d78B6ABC328b4d3B714F76F384eCC7147e1"; 
    let aaveUsdt = "0xB7b9568073C9e745acD84eEb30F1c32F74Ba4946"; 
    let foo1 = await lenderAPR.recommend(aaveUsdt);
    console.log("lenderAPR",foo1.lender);
    console.log("lenderAPR",foo1.name);
    console.log("lenderAPR",foo1.apr.toString()); 
};
