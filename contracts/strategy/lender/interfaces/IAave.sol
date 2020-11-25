 
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
interface ILendingPoolAddressesProvider {
    function getLendingPool() external view returns (address);
    function getLendingPoolCore() external view returns (address);
}

interface IAToken {
    function redeem(uint256 amount) external;
}

interface ILendingPool {
    function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external;
}
