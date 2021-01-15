// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../interfaces/IStrategy.sol";
import "../interfaces/IController.sol";

contract EarnController is Ownable, IController {
    using SafeERC20 for IERC20;

    address public strategist;
    address public vault;
    address public lendingPoolController;
    mapping(address => address) public strategies;

    modifier onlyLendingPoolController() {
        require(
            msg.sender == lendingPoolController,
            "Ownable: caller is not the LendingPoolController"
        );
        _;
    }

    constructor(address _vault, address _lendingPoolController) public {
        vault = _vault;
        lendingPoolController = _lendingPoolController;
    }
 

    function setVault(address _vault) public onlyOwner {
        vault = _vault;
    }

    function setLendingPoolController(address _lendingPoolController) public onlyOwner {
        lendingPoolController = _lendingPoolController;
    }

    function getVault() public view override returns (address) {
        return vault;
    }

    function setStrategy(address _token, address _strategy) public onlyOwner {
        address current = strategies[_token]; 
        if (current != address(0)) { 
            require(IStrategy(current).balanceOf()>100);
            //TODO IStrategy(current).withdrawAll();
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

    function earn(address _token,uint256 amount) public override onlyLendingPoolController returns (uint256){
        address strategy = strategies[_token];
        address want = IStrategy(strategy).getWant();
        require(want == _token, "strategy want not equal token");
        return IStrategy(strategy).deposit(amount);
    }

    function balanceOf(address _token)
        external
        view
        override
        returns (uint256)
    {
        return IStrategy(strategies[_token]).balanceOf();
    }

    function withdraw(address _token, uint256 _amount)
        public
        override
        onlyLendingPoolController
    {
        IStrategy(strategies[_token]).withdraw(_amount);
    }
}
