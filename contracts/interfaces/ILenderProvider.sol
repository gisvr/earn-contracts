// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ILenderProvider {
    function supply(address _token) external;

    function redeem(address _token) external;

    function balance(address _token) external returns (uint256);
}
