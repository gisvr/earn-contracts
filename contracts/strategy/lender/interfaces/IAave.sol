 
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
 
interface IAToken {
    function redeem(uint256 amount) external;
}

interface IAave {
    function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external;
}
