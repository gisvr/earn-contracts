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

    function balanceOf(address) external view returns (uint);

    function earn(address, uint) external;
}

//interface Controller {
//    function withdraw(address, uint) external;
//    function balanceOf(address) external view returns (uint);
//    function earn(address, uint) external;
//}
