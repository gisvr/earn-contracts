
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ICToken {  
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
    function claimComp(address holder) external;  
    function compAccrued(address holder) external view returns (uint256); // comp balance
    function getCompAddress() external view returns (address); //get comp  ERC20 address
    function compClaimThreshold() external view returns (uint256); 
}

interface IInterestRateModel {
    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
}
