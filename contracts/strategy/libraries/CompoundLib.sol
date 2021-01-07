// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/ICompound.sol";

library CompoundLib {
    using SafeMath for uint256;
 
   bytes32 internal constant Name = keccak256(abi.encodePacked("Compound"));

    function suply(address _lpToken, uint256 _amount,bool isEth) internal  {  
        if(isEth){ 
          (bool result,) =  _lpToken.call{value:_amount}("");
          require(result, "COMPOUND:transfer of ETH failed");
        }else{
          require(ICompound(_lpToken).mint(_amount) == 0, "COMPOUND: supply failed");
        }  
    }

    function cTokenBalanceOf(address _lpToken, address _account) internal view returns (uint) {
       return ICompound(_lpToken).balanceOf(_account);  
    }
 
    function balanceOf(address _lpToken, address _account) internal view returns (uint) {
        uint _balance = cTokenBalanceOf(_lpToken,_account); 
        if (_balance > 0) {
          // Mantisa 1e18 to decimals
          _balance = _balance.mul(ICompound(_lpToken).exchangeRateStored()).div(1e18);  
        }
        return _balance;
    }
 
    // 按照 ctoken 的余额提现
    function withdraw(address _lpToken, uint256 _amount) internal  { 
      uint256 _bal = cTokenBalanceOf(_lpToken,msg.sender);
      require(_amount>_bal,"COMPOUND: witharw gt user balance");
      require(ICompound(_lpToken).redeem(_amount) == 0, "COMPOUND: redeem failed");
    }

    //  按照 asset 的余额提现
    function withdrawSome(address _lpToken, uint256 _amount) internal returns (uint256)  {
      _amount = _amount.mul(1e18).div(ICompound(_lpToken).exchangeRateStored()); 
      if(_amount >0){
         withdraw(_lpToken,_amount);
         return _amount;
      } 
    }
 
} 