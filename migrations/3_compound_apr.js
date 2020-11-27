/*
* @title set reserve params
* @author Mint
32. 执行PriceOracle.setEthUsdPrice(mock手动方式）
33. 执行PriceOracle.setAssetPrice (精度 1e18，相对于ETH的价格)
34. 执行LendingRateOracle.setMarketBorrowRate(精度1e27)
* */

const CompoundAPR = artifacts.require("CompoundAPR");

module.exports = async (deployer, network, accounts) => { 
    let [ower, devAddr] = accounts
    let compComptroller =""
    // https://compound.finance/docs#networks
    if (network == "ropsten") {
        compComptroller = "0x54188bbedd7b68228fa89cbdda5e3e930459c6c6"
    }else if(network == "mainnet"){
        compComptroller = "0x3d9819210a31b4961b30ef54be2aed79b9c9cd3b"
    }

    

   
    await deployer.deploy(CompoundAPR,[compComptroller]);
    let compoundAPR = await CompoundAPR.deployed();
    if (network == "ropsten") {
        compoundAPR.setCETH("0xBe839b6D93E3eA47eFFcCA1F27841C917a8794f3")
    }else if(network == "mainnet"){
        compoundAPR.setCETH("0xBe839b6D93E3eA47eFFcCA1F27841C917a8794f3")
    }

    
};
