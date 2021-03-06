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

    function setEarnController(address _controller) public {
        controller = _controller;
    }

    // strategy balance + vault balance
    function balanceAll(address _token) public view returns (uint256) {
        uint256 bal = address(this).balance;
        if (_token != 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            bal = IERC20(_token).balanceOf(address(this));
        }
        return bal.add(IController(controller).balanceOf(_token));
    }

    function balance(address _token) public view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function vaultTransfer(address _token,address _strategy ) public {
        // address strategy = IController(controller).getStrategy(_token);
        uint256 bal = address(this).balance;
        if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            (bool result, ) = address(_strategy).call{value: bal}("");
            require(result, "transfer of ETH failed");
        } else {
            bal = IERC20(_token).balanceOf(address(this));
            IERC20(_token).safeTransfer(_strategy, bal);
        } 
    }

    receive() external payable {}

 
    function inCaseTokenGetsStuck(IERC20 _tokenAddress) public {
        uint256 qty = _tokenAddress.balanceOf(address(this));
        _tokenAddress.transfer(msg.sender, qty);
    }

    function inCaseETHGetsStuck() public {
        uint256 bal = address(this).balance;
        (bool result, ) = msg.sender.call{value: bal}("");
        require(result, "transfer of ETH failed");
    }
}
