// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IStrategy {

    function getWant() external view returns(address);

    function deposit(uint256) external  payable returns(uint256);

    function withdraw(uint256) external;

    function withdrawAll() external returns (uint256);

    function balanceOf() external view returns (uint256);
}
