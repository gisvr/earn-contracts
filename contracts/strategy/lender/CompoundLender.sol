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
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "../../interfaces/ILenderProvider.sol";
import "./interfaces/ICompound.sol";

contract CompoundLender is Ownable {
    using SafeMath for uint256;
    using Address for address; 
    using EnumerableMap for EnumerableMap.UintToAddressMap;
 

    function supply(address token,uint256 amount) public   {
           require(ICToken(token).mint(amount) == 0, "COMPOUND: supply failed");
    }
 
    function balance(address token) public returns (uint256)    {
        uint amount = ICToken(token).balanceOf(msg.sender);
        return amount;
    }

    function redeem(address token,uint256 amount) public {
         require(ICToken(token).redeem(amount) == 0, "COMPOUND: withdraw failed");
    }
 


}
