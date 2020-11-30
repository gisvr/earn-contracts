/*
* @title set reserve params
* @author Mint
32. 执行PriceOracle.setEthUsdPrice(mock手动方式）
33. 执行PriceOracle.setAssetPrice (精度 1e18，相对于ETH的价格)
34. 执行LendingRateOracle.setMarketBorrowRate(精度1e27)
* */

const mController = artifacts.require("mController");
const LenderAPR = artifacts.require("LenderAPR");
const StrategyLender = artifacts.require("StrategyLender");

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(LenderAPR);
    let strategyLender = await StrategyLender.deployed(); 
    
    let aaveDAI,compZRX
    if (network == "ropsten") {
        aaveDAI = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A" // aave
        compZRX = "0x00e02a5200ce3d5b5743f5369deb897946c88121" // comp
    } 

    strategyLender.
    
};