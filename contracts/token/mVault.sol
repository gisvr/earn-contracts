/**
 *Submitted for verification at Etherscan.io on 2020-07-26
 https://etherscan.io/address/0x5dbcf33d8c2e976c6b560249878e6f1491bca25c#code
 //yyDAI+yUSDC+yUSDT+yTUSD

https://etherscan.io/address/0x597ad1e0c13bfe8025993d9e79c69e1c0233522e#code
 // yUSDC

 https://etherscan.io/address/0x29e240cfd7946ba20895a7a02edb25c210f9f324#code
  // yaLink
*/
// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../interfaces/IController.sol";

contract mVault {
    using SafeERC20 for IERC20; 
    using SafeMath for uint256; 
    address public controller;
    
    function setController(address _controller) public   {
        controller = _controller;
    }
 
     
    // 计算和vault 和 stragy 上的所有的 资产余额 
    function balanceAll(address _token) public view returns (uint) {
        return IERC20(_token).balanceOf(address(this)) // 合约余额
        .add(IController(controller).balanceOf(_token)); // 策略余额
    }
    
    // 计算和vault 和 stragy 上的所有的 资产余额 
    function balance(address _token) public view returns (uint) {
        return IERC20(_token).balanceOf(address(this)); // 策略余额
    }
 

    // 发车
    // 1.将Vault可用的token资产转移到 controller
    // 2.通过contorller 操作 strategy。 earn token
    // 3. vault的 balance 为 0 可以进程充值
    function earn(address _token) public {
        uint _bal = IERC20(_token).balanceOf(address(this)); 
        IERC20(_token).safeTransfer(controller, _bal);
        IController(controller).earn(_token, _bal);
    }

    // 1 将 vault 支持的token资产 充值到 vault
    // 2 按照充值给用户分配 share
    function deposit(address _token,uint _amount) external {  
         IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
    }
    
    function approve(address _token,address _app) external { 
         IERC20(_token).safeIncreaseAllowance(_app, 10000); 
    }

    // No rebalance implementation for lower fees and faster swaps
    function withdraw(address _token,uint _amount) external {  
        IController(controller).withdraw(_token, _amount); 
    }
    
    // incase of half-way error
    function inCaseTokenGetsStuck(IERC20 _TokenAddress) public {
        uint qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(msg.sender, qty);
    }
    // incase of half-way error
    function inCaseETHGetsStuck()   public  {
        uint256 _bal = address(this).balance;
        (bool result,) =  msg.sender.call{value:_bal}("");
        require(result, "transfer of ETH failed");
    }
 
}
