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

module.exports = async (deployer) => { 
    let controller = await mController.deployed();
    let lenderAPR = await LenderAPR.deployed(); 
    await deployer.deploy(StrategyLenderETH,controller.address,lenderAPR.address);
    let strategy  = await StrategyLenderETH.deployed();

    // 设置 recommend
    await strategy.deposit();
};
