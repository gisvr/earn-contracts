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
    let [ower, user1] = accounts
    let controller = await mController.deployed();
    let lenderAPR = await LenderAPR.deployed();

    let aaveDAI 
    if (network == "ropsten" || network =="develop") {
        aaveDAI = "0x9F7A946d935c8Efc7A8329C0d894A69bA241345A" // aave 
    }

    await deployer.deploy(StrategyLender,controller.address,aaveDAI,lenderAPR.address,{from:user1});

};
