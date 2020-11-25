// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ILender  {
    function getAPR(address token) external view returns (uint256);
    // 调整收益率 - 可操作的量
    function getAPRAdjusted(address token, uint256 _supply) external view returns (uint256);
}
