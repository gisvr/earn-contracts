// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ILendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);

    function getLendingPoolCore() external view returns (address);
}

interface ILendingPool { 
    function getReserveData(address _reserve)
        external
        view
        returns (
            uint256 totalLiquidity,
            uint256 availableLiquidity,
            uint256 totalBorrowsStable,
            uint256 totalBorrowsVariable,
            uint256 liquidityRate,
            uint256 variableBorrowRate,
            uint256 stableBorrowRate,
            uint256 averageStableBorrowRate,
            uint256 utilizationRate,
            uint256 liquidityIndex,
            uint256 variableBorrowIndex,
            address aTokenAddress,
            uint40 lastUpdateTimestamp
        );
}

interface ILendingPoolCore { 
    
    function getReserveATokenAddress(address _reserve)
        external
        view
        returns (address);
 
    function getReserveCurrentLiquidityRate(address _reserve)
        external
        view
        returns (uint256);
 
    function getReserveInterestRateStrategyAddress(address _reserve)
        external
        view
        returns (address);
 
    function getReserveTotalBorrows(address _reserve)
        external
        view
        returns (uint256);
 
    function getReserveTotalBorrowsStable(address _reserve)
        external
        view
        returns (uint256);
 
    function getReserveTotalBorrowsVariable(address _reserve)
        external
        view
        returns (uint256);
 
    function getReserveCurrentAverageStableBorrowRate(address _reserve)
        external
        view
        returns (uint256);
 
    function getReserveAvailableLiquidity(address _reserve)
        external
        view
        returns (uint256);
}

interface IReserveInterestRateStrategy {
    function getBaseVariableBorrowRate() external view returns (uint256);

    function calculateInterestRates(
        address _reserve,
        uint256 _utilizationRate,
        uint256 _totalBorrowsStable,
        uint256 _totalBorrowsVariable,
        uint256 _averageStableBorrowRate
    )
        external
        view
        returns (
            uint256 liquidityRate,
            uint256 stableBorrowRate,
            uint256 variableBorrowRate
        );
}
