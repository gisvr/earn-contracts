 
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
interface ILendingPoolAddressesProvider {
    // function getLendingPool() external view returns (address);
    function getLendingPoolCore() external view returns (address);
}
 
///------------oracle------------
interface ILendingPoolCore {
    // 获取资产当前的流动比例
    function getReserveCurrentLiquidityRate(address _reserve)
    external
    view
    returns (
        uint256 liquidityRate
    );

    // 获取资产利率策略地址
    function getReserveInterestRateStrategyAddress(address _reserve) external view returns (address);

    // 获取资产总借出
    function getReserveTotalBorrows(address _reserve) external view returns (uint256);

    // 获取资产总 固定利率总借出
    function getReserveTotalBorrowsStable(address _reserve) external view returns (uint256);
    // 获取资产总 浮动利率总借出
    function getReserveTotalBorrowsVariable(address _reserve) external view returns (uint256);

    // 获取资产总 当前固定平均利率
    function getReserveCurrentAverageStableBorrowRate(address _reserve)
    external
    view
    returns (uint256);

    // 获取资产可用流动性
    function getReserveAvailableLiquidity(address _reserve) external view returns (uint256);
}

interface IReserveInterestRateStrategy {
    // 获取基础利率
    function getBaseVariableBorrowRate() external view returns (uint256);

    // 计算资产 利率
    function calculateInterestRates(
        address _reserve,
        uint256 _utilizationRate,
        uint256 _totalBorrowsStable,
        uint256 _totalBorrowsVariable,
        uint256 _averageStableBorrowRate)
    external
    view
    returns (uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate);
    // 提供流动性的利率，固定借利率，浮动借利率
}
 