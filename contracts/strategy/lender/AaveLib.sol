// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IAave.sol";

library AaveLib {
    using SafeMath for uint256;
    struct Aave { 
        address lendingPool; 
        address core;  
    }
 
    bytes32 internal constant AaveName = keccak256(abi.encodePacked("Aave"));
  
    function suply(Aave memory aave,address _token, uint256 _amount) internal  {
       IAave(aave.lendingPool).deposit(_token, _amount, 0);
    }

    // function balanceOf(address _lpToken, address _account) internal view returns (uint) {
    //     uint _balance = IERC20(_lpToken).balanceOf(_account); 
    //     // Mantisa 1e18 to decimals
    //     return _balance.mul(ICompound(_lpToken).exchangeRateStored()).div(1e18);  
    // }

    // function redeem(address _lpToken, uint256 _balance) internal  {
    //     _balance = _balance.mul(ICompound(_lpToken).exchangeRateStored()).div(1e18); 
    //     require(ICompound(_lpToken).redeem(_balance) == 0, "COMPOUND: redeem failed");
    // }
 
} 