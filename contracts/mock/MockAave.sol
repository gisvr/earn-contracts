// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "../strategy/apr/interfaces/IAave.sol"; 

contract LendingPoolAddressesProvider is ILendingPoolAddressesProvider {
    address public coreAddress;
    function getLendingPoolCore() override(ILendingPoolAddressesProvider) public view returns (address){
        return coreAddress;
    }

    function setLendingPoolCore(address _coreAddress)  public {
          coreAddress = _coreAddress;
    }
}

contract LendingPoolCore is ILendingPoolCore {
    address strategyAddress;
    uint currentLiquidityRate = 2*1e27;
    // 获取资产当前的流动比例
    function getReserveCurrentLiquidityRate(address _reserve)
        override(ILendingPoolCore)
        public
        view
    returns (
        uint256 liquidityRate
    ){
        return currentLiquidityRate;
    }

    // 获取资产利率策略地址
    function getReserveInterestRateStrategyAddress(address _reserve) 
        override(ILendingPoolCore)
        public
        view
     returns (address){
         return strategyAddress;
     }

     function setReserveInterestRateStrategyAddress(address _strategyAddress) 
        public {
         strategyAddress = _strategyAddress;
     }

    // 获取资产总借出
    function getReserveTotalBorrows(address _reserve) 
        override(ILendingPoolCore)
        public
        view
     returns (uint256){
         return 1;
     }

    // 获取资产总 固定利率总借出
    function getReserveTotalBorrowsStable(address _reserve)  
        override(ILendingPoolCore)
        public
        view
     returns (uint256){
         return 1;
     }
    // 获取资产总 浮动利率总借出
    function getReserveTotalBorrowsVariable(address _reserve)  
        override(ILendingPoolCore)
        public
        view
     returns (uint256){
         return 1;
     }

    // 获取资产总 当前固定平均利率
    function getReserveCurrentAverageStableBorrowRate(address _reserve)
        override(ILendingPoolCore)
        public
        view
     returns (uint256){
         return 1;
     }

    // 获取资产可用流动性
    function getReserveAvailableLiquidity(address _reserve) 
        override(ILendingPoolCore)
        public
        view
     returns (uint256){
         return 1;
     }
}

contract ReserveInterestRateStrategy is IReserveInterestRateStrategy {
    address coreAddress;
    // 获取基础利率
    function getBaseVariableBorrowRate()
        override(IReserveInterestRateStrategy)
        public
        view
     returns (uint256){
         return 1;
     }

    // 计算资产 利率
    function calculateInterestRates(
        address _reserve,
        uint256 _utilizationRate,
        uint256 _totalBorrowsStable,
        uint256 _totalBorrowsVariable,
        uint256 _averageStableBorrowRate)
        override(IReserveInterestRateStrategy)
        public
        view
    returns (uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate){
        return (6*1e27,1,1);
    }
    // 提供流动性的利率，固定借利率，浮动借利率
}
