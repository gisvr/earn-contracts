/**
 *Submitted for verification at Etherscan.io on 2020-08-11
*/

/**
 *Submitted for verification at Etherscan.io on 2020-07-26

 https://etherscan.io/address/0x9e65ad11b299ca0abefc2799ddb6314ef2d91080#code

*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

// import "../interfaces/IOneSplitAudit.sol";
import "../interfaces/IControllerStrategy.sol";
import "../interfaces/IController.sol";



// 面向vault 提供 conver 和 exchange 操作
contract mController is Ownable,IController {
    using SafeERC20 for IERC20;
    // using Address for address;
    // using SafeMath for uint256;
 
    address public strategist; 
    address public rewards;
    address public override vault; // 对接的包含资产的合约
    mapping(address => address) public strategies;  

    constructor(address _vault) public { 
        vault = _vault;
    }
 
    function setVault(address _vault) public onlyOwner{ 
        vault  = _vault;
    } 

    // 重新设置资产策略，全部提回资产
    function setStrategy(address _token, address _strategy) public onlyOwner { 
        address _current = strategies[_token];
        if (_current != address(0)) {
            IControllerStrategy(_current).withdrawAll();
        }
        strategies[_token] = _strategy;
    }

    // 往策略中传递资产
    function earn(address _token, uint _amount) public override{
        address _strategy = strategies[_token]; 
        address _want = IControllerStrategy(_strategy).want();
        require(_want == _token, "strategy want not equal token");
        // 给策略地址 --> 转入余额 
        IERC20(_want).safeTransfer(_strategy, _amount); 
        IControllerStrategy(_strategy).deposit();
    }

    function balanceOf(address _token) external view override returns (uint) {
        return IControllerStrategy(strategies[_token]).balanceOf(_token);
    }

    function withdraw(address _token, uint _amount) public override{
        // require(msg.sender == vault, "!vault");
        IControllerStrategy(strategies[_token]).withdraw(_amount);
    } 
    
    
    // incase of half-way error
    function inCaseTokenGetsStuck(IERC20 _TokenAddress)   public onlyOwner{
        uint qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(msg.sender, qty);
    }
    // incase of half-way error
    function inCaseETHGetsStuck()   public  onlyOwner{
        uint256 _bal = address(this).balance;
        (bool result,) =  msg.sender.call{value:_bal}("");
        require(result, "transfer of ETH failed");
    }

}
