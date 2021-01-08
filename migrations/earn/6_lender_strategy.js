/*
* @title set reserve params
* @author Mint
32. 执行PriceOracle.setEthUsdPrice(mock手动方式）
33. 执行PriceOracle.setAssetPrice (精度 1e18，相对于ETH的价格)
34. 执行LendingRateOracle.setMarketBorrowRate(精度1e27)
* */
let nodeProvider = require("../../utils/ganache.provider");
const EarnController = artifacts.require("EarnController");
const LenderAPR = artifacts.require("LenderAPR");
const StrategyLender = artifacts.require("StrategyLender");

module.exports = async (deployer) => {
    let controller = await EarnController.deployed();
    let lenderAPR = await LenderAPR.deployed();
 

    let TokenWBTC = await nodeProvider.getAave("MockWBTC");
    let TokenDAI = await nodeProvider.getAave("MockDAI");
    let TokenBAT = await nodeProvider.getAave("MockBAT");
    let TokenUSDT = await nodeProvider.getAave("MockUSDT");
    let TokenUSDC = await nodeProvider.getAave("MockUSDC");
    let ETH = {address:"0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"}

    let mockToken = [ETH,TokenWBTC, TokenDAI, TokenBAT, TokenUSDT, TokenUSDC]
    for (let token of mockToken) {
        let addr = token.address
        // address _want,
        // address _controller,
        // address _apr
        await deployer.deploy(StrategyLender, addr, controller.address, lenderAPR.address);

        let strategy = await StrategyLender.deployed();
        await controller.setStrategy(addr, strategy.address)
    }


};
