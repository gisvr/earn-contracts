/**
 *Submitted for verification at Etherscan.io on 2020-02-06
 https://etherscan.io/address/0xeC3aDd301dcAC0e9B0B880FCf6F92BDfdc002BBc#code
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/EnumerableMap.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/ILenderProvider.sol";

contract LenderProvider is Ownable {
    using SafeMath for uint256;
    using Address for address; 
    using EnumerableMap for EnumerableMap.UintToAddressMap;
 
    // incase of half-way error
    function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
        uint qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(msg.sender, qty);
    }
   // incase of half-way error
    function inCaseETHGetsStuck() onlyOwner public {
        uint256 _bal = address(this).balance;
        (bool result,) =  msg.sender.call{value:_bal}("");
        require(result, "transfer of ETH failed");
    }
}
