// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../interfaces/IStrategy.sol";
import "../interfaces/IController.sol";

contract EarnController is Ownable, IController {
    using SafeERC20 for IERC20;

    address public strategist;
    address public rewards;
    address public vault;
    address public lendingPoolController;
    mapping(address => address) public strategies;

    modifier onlyLendingPoolController() {
        require(
            msg.sender == lendingPoolController,
            "Ownable: caller is not the vault"
        );
        _;
    }

    modifier onlyVault() {
        require(msg.sender == vault, "Ownable: caller is not the vault");
        _;
    }

    constructor(address _vault, address _lendingPoolController) public {
        vault = _vault;
        lendingPoolController = _lendingPoolController;
    }

    receive() external payable {}

    function setVault(address _vault) public onlyOwner {
        vault = _vault;
    }

    function getVault() public view override returns (address) {
        return vault;
    }

    function setStrategy(address _token, address _strategy) public onlyOwner {
        address current = strategies[_token];
        if (current != address(0)) {
            IStrategy(current).withdrawAll();
        }
        strategies[_token] = _strategy;
    }

    function getStrategy(address _token)
        public
        view
        override
        returns (address)
    {
        return strategies[_token];
    }

    function earn(address _token) public override onlyVault {
        address strategy = strategies[_token];
        address want = IStrategy(strategy).getWant();
        require(want == _token, "strategy want not equal token");
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

    function withdraw(address _token, uint256 _amount)
        public
        override
        onlyLendingPoolController
    {
        IStrategy(strategies[_token]).withdraw(_amount);
    }
}
