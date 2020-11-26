// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ILenderProvider  { 
    // 供应
    function supply(address _token) external ;
    // 赎回
    function redeem(address _token) external ;
    // 余额
    function balance(address _token) external returns (uint256);
}
