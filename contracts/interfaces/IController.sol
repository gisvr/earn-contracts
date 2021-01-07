// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IController {
    function vault() external view returns (address);

    function withdraw(address, uint256) external;

    // Vault token_balance + strategy_balance
    function balanceOf(address) external view returns (uint256);

    // Vault depoist and run strategy
    function earn(address, uint256) external;
}
