/**
 *Submitted for verification at Etherscan.io on 2020-08-11
*/

/**
 *Submitted for verification at Etherscan.io on 2020-07-26

 https://etherscan.io/address/0x9e65ad11b299ca0abefc2799ddb6314ef2d91080#code

*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IStrategy {
    function deposit() external payable;
    function withdraw(address) external;
    function withdraw(uint) external;
    function withdrawAll() external returns (uint);
    function balanceOf() external view returns (uint);
    function harvest() external;// 收割
}
