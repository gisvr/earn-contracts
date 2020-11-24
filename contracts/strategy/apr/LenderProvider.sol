/**
 *Submitted for verification at Etherscan.io on 2020-02-06
 https://etherscan.io/address/0xeC3aDd301dcAC0e9B0B880FCf6F92BDfdc002BBc#code
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/EnumerableMap.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/ILenderProvider.sol";

contract LenderProvider is Ownable,ILenderProvider {
    using SafeMath for uint256;
    using Address for address; 
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    LenderInfo[]  reservesList; 

    function recommend(address token) public override(ILenderProvider)   returns (LenderInfo memory) {
        require(token!=address(0)); 
        return LenderInfo({lenderTokenAddr:0x6B175474E89094C44Da98b954EedeAC495271d0F,apr:1});
    }

    
     
    function recommendAll(address token) public override(ILenderProvider)   returns (LenderInfo[]  memory) {
        reservesList.push( LenderInfo({lenderTokenAddr:token,apr:1})); 
        return  reservesList;
    }
 

    // incase of half-way error
    function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
        uint qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(msg.sender, qty);
    }
    // incase of half-way error
    function inCaseETHGetsStuck() onlyOwner public {
        (bool result,) = msg.sender.call.value(address(this).balance)("");
        require(result, "transfer of ETH failed");
    }
}
