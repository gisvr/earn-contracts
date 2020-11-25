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

contract mVault is ERC20 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    IERC20 public token;

    uint public min = 10000;
    uint public constant max = 10000;

    address public governance;
    address public controller;

    // 根据支持的资产信息创建 vault, 
    // 定义 contraller 通过 controller 操作strategy
    constructor (address _token, address _controller) public ERC20(
        string(abi.encodePacked("mEarn ", ERC20(_token).name())),
        string(abi.encodePacked("m", ERC20(_token).symbol()))
    ) {
        token = IERC20(_token);
        _setupDecimals(ERC20(_token).decimals());
        governance = msg.sender;
        controller = _controller;
    }

    function balance() public view returns (uint) {
        return token.balanceOf(address(this))
        .add(IController(controller).balanceOf(address(token)));
    }

    function setMin(uint _min) external {
        require(msg.sender == governance, "!governance");
        min = _min;
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function setController(address _controller) public {
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }

    // Custom logic in here for how much the vault allows to be borrowed
    // Sets minimum required on-hand to keep small withdrawals cheap
    function available() public view returns (uint) {
        return token.balanceOf(address(this)).mul(min).div(max);
    }

    // 发车
    // 1.将Vault可用的token资产转移到 controller
    // 2.通过contorller 操作 strategy。 earn token
    // 3. vault的 balance 为 0 可以进程充值
    function earn() public {
        uint _bal = available();
        token.safeTransfer(controller, _bal);
        IController(controller).earn(address(token), _bal);
    }

    // 1 将 vault 支持的token资产 充值到 vault
    // 2 按照充值给用户分配 share
    function deposit(uint _amount) external {
        uint _pool = balance();
        // _pool == 0 异常 必须将 pool 清空
        // require(_pool == 0, "!_pool = 0");
        token.safeTransferFrom(msg.sender, address(this), _amount);
        uint shares = 0;
        if (_pool == 0) {
            shares = _amount;
        } else {
            shares = (_amount.mul(totalSupply())).div(_pool);//
        }
        _mint(msg.sender, shares);
        //  earn();
    }

    // No rebalance implementation for lower fees and faster swaps
    function withdraw(uint _shares) external {
        uint r = (balance().mul(_shares)).div(totalSupply());
        _burn(msg.sender, _shares);

        // Check balance
        uint b = token.balanceOf(address(this));
        if (b < r) {
            uint _withdraw = r.sub(b);
            IController(controller).withdraw(address(token), _withdraw);
            uint _after = token.balanceOf(address(this));
            uint _diff = _after.sub(b);
            if (_diff < _withdraw) {
                r = b.add(_diff);
            }
        }

        token.safeTransfer(msg.sender, r);
    }

    function getPricePerFullShare() public view returns (uint) {
        return balance().mul(1e18).div(totalSupply());
    }
}
