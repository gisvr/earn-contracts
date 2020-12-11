/**
 *Submitted for verification at Etherscan.io on 2020-08-11
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface IStrategy {
    function deposit() external payable;
    function withdraw(uint) external; 
    function withdrawAll() external returns (uint);
    function balanceOf(address _want) external view returns (uint);

}
