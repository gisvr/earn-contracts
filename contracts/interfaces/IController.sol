/**
 *Submitted for verification at Etherscan.io on 2020-08-24
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IController {
    // strategy
    function vaults(address) external view returns (address);

    function rewards() external view returns (address);

    // Vault
    function withdraw(address, uint) external;

    // Vault token_balance + strategy_balance
    function balanceOf(address) external view returns (uint);

    //Vault depoist and run strategy
    function earn(address, uint) external;
}
