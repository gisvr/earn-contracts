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

    let compZRX = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c" // underlyin

    await deployer.deploy(StrategyLender,controller.address,compZRX,lenderAPR.address,{from:user1});

    let strategy  = await StrategyLender.deployed();

    // 设置 recommend
    await strategy.deposit();

    // 设置 controller
    await controller.approveStrategy(compZRX,strategy.address,{from:user1});
    await controller.setStrategy(compZRX,strategy.address,{from:user1});
    console.log("controller",controller.address)
};
