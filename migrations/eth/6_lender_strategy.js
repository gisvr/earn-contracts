/*
* @title set reserve params
* @author Mint
32. 执行PriceOracle.setEthUsdPrice(mock手动方式）
33. 执行PriceOracle.setAssetPrice (精度 1e18，相对于ETH的价格)
34. 执行LendingRateOracle.setMarketBorrowRate(精度1e27)
* */

const mController = artifacts.require("mController");
const LenderAPR = artifacts.require("LenderAPR");
const StrategyLenderETH = artifacts.require("StrategyLenderETH");

module.exports = async (deployer, network, accounts) => {
    let [ower, user1] = accounts
    let controller = await mController.deployed();
    let lenderAPR = await LenderAPR.deployed();

    let aaveDAI,compZRX
    if (network == "ropsten" || network =="develop") {
        aaveDAI = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A" // aave
        compZRX = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c" // comp underlying
    }


    await deployer.deploy(StrategyLenderETH,controller.address,lenderAPR.address,{from:user1});

};
