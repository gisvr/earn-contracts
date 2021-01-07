
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ICToken { 
    //---------------- oracle ------------
    function interestRateModel() external view returns (address);

    function reserveFactorMantissa() external view returns (uint256);

    function totalBorrows() external view returns (uint256);

    function totalReserves() external view returns (uint256);

    function supplyRatePerBlock() external view returns (uint);

    function getCash() external view returns (uint256);

    function underlying() external view  returns (address);
}

interface IComptroller {
    function getAllMarkets() external view returns (address[] memory);
    function claimComp(address holder) external; // 自己提取 Comp
    function compAccrued(address holder) external view returns (uint256); // 持有的 comp
    function getCompAddress() external view returns (address); //获取 comp 的地址  ERC20
    function compClaimThreshold() external view returns (uint256); // 提取阀值
}

interface IInterestRateModel {
    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
}
