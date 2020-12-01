/**
 *Submitted for verification at Etherscan.io on 2020-02-06
 https://etherscan.io/address/0xeC3aDd301dcAC0e9B0B880FCf6F92BDfdc002BBc#code
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0; 

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol"; 
import "./interfaces/IAave.sol";
import "./interfaces/IAPR.sol";


contract AaveAPR  is Ownable,IAPR {
    using SafeMath for uint256;
    using Address for address;
    address  Aave; 
    string  lenderName = "Aave";

    // 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8 mainnet
    constructor(address _provider) public {
        Aave = _provider; 
    }

    function getAaveCore() public view returns (address) {
        return address(ILendingPoolAddressesProvider(Aave).getLendingPoolCore());
    }

    function getAave()  view  public returns (address) {
        return address(ILendingPoolAddressesProvider(Aave).getLendingPool());
    }

    function getController(bool _core)  view  public override returns (address) {
        if(_core){
            return getAaveCore();
        }else{
            return getAave();
        } 
    }
    

    function initialize(address _addressesProvider) public onlyOwner {
        Aave = _addressesProvider; 
    }

    function name() public override view returns (string memory){
        return lenderName;
    }

    function getLpToken(address token) public override view returns (address){
        address aave = getAave();
        ILendingPool lendPool = ILendingPool(aave);
        (,,,,,,,,,,,address aTokenAddress,) = lendPool.getReserveData(token);
        return aTokenAddress; 
    }

    /*
        get APR
    */ 
    function getAPR(address token) public override view returns (uint256) {
        address aaveCore = getAaveCore();
        ILendingPoolCore core = ILendingPoolCore(aaveCore);
        // 资产当前的流动性比率， 统一单位 到 e18 aave的单位是e27
        return core.getReserveCurrentLiquidityRate(token).div(1e9);
    }

    function getAPRAdjusted(address token, uint256 _supply) public override view returns (uint256) {
        address AaveCore = getAaveCore();
        ILendingPoolCore core = ILendingPoolCore(AaveCore);
        //获得资产的利率策略
        IReserveInterestRateStrategy apr = IReserveInterestRateStrategy(core.getReserveInterestRateStrategyAddress(token));
        //计算利率
        (uint256 newLiquidityRate,,) = apr.calculateInterestRates(
            token,
            core.getReserveAvailableLiquidity(token).add(_supply), // 可用的流动性
            core.getReserveTotalBorrowsStable(token), // 总共的固定利率借出
            core.getReserveTotalBorrowsVariable(token), // 总计浮动利率借出
            core.getReserveCurrentAverageStableBorrowRate(token) // 当前平均固定借出利率
        );
        // aave 的利率是 27位
        return newLiquidityRate.div(1e9);
    }

}
