// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../interfaces/IStrategy.sol";
import "../interfaces/IController.sol";

contract mController is Ownable, IController {
    using SafeERC20 for IERC20;

    address public strategist;
    address public rewards;
    address public override vault;
    mapping(address => address) public strategies;

    constructor(address _vault) public {
        vault = _vault;
    }

    function setVault(address _vault) public onlyOwner {
        vault = _vault;
    }

    function setStrategy(address _token, address _strategy) public onlyOwner {
        address current = strategies[_token];
        if (current != address(0)) {
            IStrategy(current).withdrawAll();
        }
        strategies[_token] = _strategy;
    }

    function earn(address _token, uint256 _amount) public override {
        require(msg.sender == vault, "!vault");
        address strategy = strategies[_token];
        address want = IStrategy(strategy).want();
        require(want == _token, "strategy want not equal token");

        IERC20(want).safeTransfer(strategy, _amount);
        IStrategy(strategy).deposit();
    }

    function balanceOf(address _token)
        external
        view
        override
        returns (uint256)
    {
        return IStrategy(strategies[_token]).balanceOf(_token);
    }

    function withdraw(address _token, uint256 _amount) public override {
        require(msg.sender == vault, "!vault");
        IStrategy(strategies[_token]).withdraw(_amount);
    }

    function inCaseTokenGetsStuck(IERC20 _tokenAddress) public onlyOwner {
        uint256 qty = _tokenAddress.balanceOf(address(this));
        _tokenAddress.transfer(msg.sender, qty);
    }

    function inCaseETHGetsStuck() public onlyOwner {
        uint256 bal = address(this).balance;
        (bool result, ) = msg.sender.call{value: bal}("");
        require(result, "transfer of ETH failed");
    }
}
