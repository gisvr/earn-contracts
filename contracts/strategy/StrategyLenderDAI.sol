// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../interfaces/IStrategy.sol";
import "../../interfaces/IDforce.sol";
//import "../interfaces/IController.sol";

contract StrategyLenderDAI is IStrategy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    address constant public want = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); // USDC
    address constant public dusdc = address(0x16c9cF62d8daC4a38FB50Ae5fa5d51E9170F3179);

    address public governance;
    address public controller;
    address public strategist;

    constructor(address _controller) public {
        governance = msg.sender;
        strategist = msg.sender;
        controller = _controller;
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
