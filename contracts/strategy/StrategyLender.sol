// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../interfaces/IStrategy.sol";
import "../interfaces/ILenderProvider.sol";

import "../interfaces/IDforce.sol"; 
import "../interfaces/IController.sol";
import "./lender/interfaces/ICompound.sol";

contract StrategyLender is IStrategy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256; 

    address public want;
    address public governance;
    address public controller;
    address public strategist;

    constructor (address _controller, address _want) public {
        want = address(_want);
        governance = msg.sender;
        strategist = msg.sender;
        controller = _controller;
    }
    
    // function reserve() public view returns (address) {
    //     return IController(controller).want(address(this));
    // }

    // function recommend() override(ILenderProvider) public view returns (LenderInfo memory) {
    //     // LenderInfo lender =;
    //     return  LenderInfo({lenderTokenAddr:0x6B175474E89094C44Da98b954EedeAC495271d0F,apr:1});
    // }

    function approveToken() public {
        // IERC20(address(this)).safeApprove(compound, uint(- 1)); 
        // IERC20(address(this)).safeApprove(getAaveCore(), uint(- 1)); 
    }


    function deposit() override(IStrategy) public {

        address _opAddres = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        uint _want = IERC20(want).balanceOf(address(this));
        //拥有资产的合约, 将想要的 ERC20资产, 授权 LP 资产的代理额度
        IERC20(want).safeIncreaseAllowance(_opAddres, _want);
        // 将合约的ERC20资产转入 LP 中，获得LP资产
        supplyCompound(want,_want);

        // if (_want > 0) {
        //            IERC20(want).safeApprove(dusdc, 0);
        //            IERC20(want).safeApprove(dusdc, _want);
        //            dERC20(dusdc).mint(address(this), _want);
        //        }
        //
        //        uint _dusdc = IERC20(dusdc).balanceOf(address(this));
        //        if (_dusdc > 0) {
        //            IERC20(dusdc).safeApprove(pool, 0);
        //            IERC20(dusdc).safeApprove(pool, _dusdc);
        //            dRewards(pool).stake(_dusdc);
        //        }
    }

    function supplyAave(address token,uint256 amount) public {
        // Aave(getAave()).deposit(token, amount, 0);
    }

    function supplyCompound(address token,uint256 amount) public {
        require(ICToken(token).mint(amount) == 0, "COMPOUND: supply failed");
    }

    function redeemCompound(address token,uint256 amount) public {
        require(ICToken(token).redeem(amount) == 0, "COMPOUND: supply failed");
    }

     function balanceCompound(address token,uint256 amount) public {
        require(ICToken(token).mint(amount) == 0, "COMPOUND: supply failed");
    }

 


    function harvest() override(IStrategy) external {

    }

    function withdraw(address) override(IStrategy) external {

    }

    function withdraw(uint) override(IStrategy) external {

    }

    function withdrawAll() override(IStrategy) external returns (uint){
        return uint(1);
    }

    function balanceOf() override(IStrategy) external view returns (uint){
        return uint(0);
    }
 
}
