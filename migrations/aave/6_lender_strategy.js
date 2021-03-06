/*
* @title set reserve params
* @author Mint
32. 执行PriceOracle.setEthUsdPrice(mock手动方式）
33. 执行PriceOracle.setAssetPrice (精度 1e18，相对于ETH的价格)
34. 执行LendingRateOracle.setMarketBorrowRate(精度1e27)
* */
let nodeProvider = require("../../utils/ganache.provider");
const mController = artifacts.require("mController");
const LenderAPR = artifacts.require("LenderAPR");
const StrategyLender = artifacts.require("StrategyLender");

module.exports = async (deployer) => {
    let controller = await mController.deployed();
    let lenderAPR = await LenderAPR.deployed();

    let _dai = await nodeProvider.getAave("MockDAI");
    let aaveDai = _dai.address;

    await deployer.deploy(StrategyLender,controller.address,aaveDai,lenderAPR.address);

    let strategy  = await StrategyLender.deployed();
    await controller.setStrategy(aaveDai,strategy.address)
};
