// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IStrategy {

    function want() external pure returns(address);

    function deposit() external payable;

    function withdraw(uint256) external;

    function withdrawAll() external returns (uint256);

    function balanceOf(address _want) external view returns (uint256);
}
