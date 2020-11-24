// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../interfaces/IStrategy.sol";
import "../interfaces/ILenderProvider.sol";

import "../interfaces/IDforce.sol";
//import "../interfaces/IController.sol";

contract StrategyLenderDAI is IStrategy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    address constant public dusdc = address(0x16c9cF62d8daC4a38FB50Ae5fa5d51E9170F3179);
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
    

    // function recommend() override(ILenderProvider) public view returns (LenderInfo memory) {
    //     // LenderInfo lender =;
    //     return  LenderInfo({lenderTokenAddr:0x6B175474E89094C44Da98b954EedeAC495271d0F,apr:1});
    // }

    function approveToken() public {
        // IERC20(address(this)).safeApprove(compound, uint(- 1)); 
        // IERC20(address(this)).safeApprove(getAaveCore(), uint(- 1)); 
    }


    function deposit() override(IStrategy) external {
        uint _want = IERC20(want).balanceOf(address(this));
        //        if (_want > 0) {
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
