
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IAToken {
   function redeem(uint256 amount) external;
   function balanceOf(address _user) external view returns (uint);
   function transfer(address recipient, uint256 amount) external;
   function transferFrom(address from, address to, uint256 amount) external;
   function principalBalanceOf(address _user) external view returns (uint);
}

interface IAave {
   function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external payable;
}
