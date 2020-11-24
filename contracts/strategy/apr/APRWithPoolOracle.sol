/**
 *Submitted for verification at Etherscan.io on 2020-02-06
 https://etherscan.io/address/0xeC3aDd301dcAC0e9B0B880FCf6F92BDfdc002BBc#code
*/

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract APRWithPoolOracle is Ownable {
    using SafeMath for uint256;
    using Address for address;

    uint256 DECIMAL = 10 ** 18;

    uint256 public liquidationRatio;
    uint256 public dydxModifier;
    uint256 public blocksPerYear = 2102400; // 1年的秒数/ 15秒出块 = 31536000/15

    function getAPR(address token) public view returns (uint256) {
        require(token!=address(0));

        return 1;
     }

    function getAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
        
        return 1;
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
