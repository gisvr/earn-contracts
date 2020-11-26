/*
* @title set reserve params
* @author Mint
32. 执行PriceOracle.setEthUsdPrice(mock手动方式）
33. 执行PriceOracle.setAssetPrice (精度 1e18，相对于ETH的价格)
34. 执行LendingRateOracle.setMarketBorrowRate(精度1e27)
* */

const AaveAPR = artifacts.require("AaveAPR");
const LenderAPR = artifacts.require("LenderAPR");

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(LenderAPR);
    let aaveAPR = await AaveAPR.deployed()
    let lenderAPR = await LenderAPR.deployed()

    let reserveDAI
    if (network == "ropsten") {
        reserveDAI = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A"
    }

    let aaveAddr = aaveAPR.address  
    await lenderAPR.addLender("AAVE", aaveAddr.address);

    let foo1 = await lenderAPR.recommend(reserveDAI)
    console.log("lenderAPR",lenderAPR.address, foo1)
};
