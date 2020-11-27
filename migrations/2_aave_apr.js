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
    // https://docs.aave.com/developers/deployed-contracts/deployed-contract-instances
    if (network == "ropsten") {
        aavePrivder = "0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728"
    }
    await deployer.deploy(AaveAPR,[aaveProvider]);
};
