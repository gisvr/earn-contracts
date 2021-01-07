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

    function setController(address _controller) public {
        controller = _controller;
    }
    // strategy balance + vault balance
    function balanceAll(address _token) public view returns (uint256) {
        return
            IERC20(_token).balanceOf(address(this)).add(
                IController(controller).balanceOf(_token)
            ); 
    }

    function balance(address _token) public view returns (uint256) {
        return IERC20(_token).balanceOf(address(this)); 
    }

    function earn(address _token) public {
        uint256 _bal = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(controller, _bal);
        IController(controller).earn(_token, _bal);
    }

    function deposit(address _token, uint256 _amount) external {
        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
    }

    function approve(address _token, address _app) external {
        IERC20(_token).safeIncreaseAllowance(_app, 10000);
    }

    function withdraw(address _token, uint256 _amount) external {
        IController(controller).withdraw(_token, _amount);
    }

    // incase of half-way error
    function inCaseTokenGetsStuck(IERC20 _TokenAddress) public {
        uint256 qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(msg.sender, qty);
    }

    // incase of half-way error
    function inCaseETHGetsStuck() public {
        uint256 _bal = address(this).balance;
        (bool result, ) = msg.sender.call{value: _bal}("");
        require(result, "transfer of ETH failed");
    }
}
