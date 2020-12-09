
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ICompound { //ICToken
    function mint(uint256 mintAmount) external  returns (uint256); 
    function redeem(uint256 redeemTokens) external returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    // 获取compound ctoken 和 underlying 资产的兑换率
    function exchangeRateStored() external view returns (uint);
}
