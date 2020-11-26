/*
* @title set reserve params
* @author Mint
32. 执行PriceOracle.setEthUsdPrice(mock手动方式）
33. 执行PriceOracle.setAssetPrice (精度 1e18，相对于ETH的价格)
34. 执行LendingRateOracle.setMarketBorrowRate(精度1e27)
* */

const AaveAPR = artifacts.require("AaveAPR");

module.exports = async (deployer, network, accounts) => { 
    let [ower, devAddr] = accounts
    let aaveProvider =""
    if (network == "ropsten") {
        aavePrivder = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A"
    }
    await deployer.deploy(AaveAPR,[aaveProvider]);
};
