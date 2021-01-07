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
 
    bytes32 internal constant Name = keccak256(abi.encodePacked("Aave"));
   
   function suply(Aave memory aave,address _token,uint256 _amount,bool isEth)  internal {  
        IAave _aave = IAave(aave.lendingPool);
        if(isEth){
           _aave.deposit{value:_amount}(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,_amount,0);
        }else{
           _aave.deposit(_token, _amount, 0);
        }  
    }

    function balanceOf(address _lpToken, address _account) internal view returns (uint) {
        // return IERC20(_lpToken).balanceOf(_account);  
       return IAToken(_lpToken).balanceOf(_account);  
    }

    function withdraw(address _lpToken, uint256 _balance) internal  returns (uint256) { 
        uint256 _balAll = balanceOf(_lpToken,address(this));
        if(_balAll>0){ 
          uint256 _bal = IAToken(_lpToken).principalBalanceOf(address(this));
          _bal = _balAll.sub(_bal).mul(_balance).div(_bal).add(_balance);
          require(_bal>=_balance,"principalBalanceOf error");
          IAToken(_lpToken).redeem(_bal);
          return _bal;
        } 
    }
 
} 