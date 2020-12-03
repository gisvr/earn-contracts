// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/ICompound.sol";

library CompoundLib {
    using SafeMath for uint256;
 
  
    function suply(address _lpToken, uint256 _amount) internal  {
        require(ICompound(_lpToken).mint(_amount) == 0, "COMPOUND: supply failed");
    }

    function balanceOf(address _lpToken, address _account) internal view returns (uint) {
        uint _balance = IERC20(_lpToken).balanceOf(_account); 
        // Mantisa 1e18 to decimals
        return _balance.mul(ICompound(_lpToken).exchangeRateStored()).div(1e18);  
    }

    function redeem(address _lpToken, uint256 _balance) internal  {
        _balance = _balance.mul(ICompound(_lpToken).exchangeRateStored()).div(1e18); 
        require(ICompound(_lpToken).redeem(_balance) == 0, "COMPOUND: redeem failed");
    }
 
} 