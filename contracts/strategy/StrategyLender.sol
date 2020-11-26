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
import "./lender/interfaces/IAave.sol";

contract StrategyLender is IStrategy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256; 

    address public want;
    address public governance;
    address public controller;
    address public strategist;
    address public recommend = 0x540d7E428D5207B30EE03F2551Cbb5751D3c7569;

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
        
        uint _balance = IERC20(want).balanceOf(address(this));
 
        if(_balance>0){
            //接受资产的合约地址
            address _lpAddres = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
            //拥有资产的合约, 将想要的 ERC20资产, 授权 LP 资产的代理额度
            IERC20(want).safeIncreaseAllowance(_lpAddres, _balance);
             // 将合约的ERC20资产转入 LP 中，获得LP资产
            supplyCompound(want,_balance);
        }
       

       
            // if (newProvider == Lender.DYDX) { 
            //     supplyCompound(balance());
            // } else if (newProvider == Lender.AAVE) {
            //     supplyAave(balance());
            // } 
    }

    function supplyAave(address token,uint256 amount) public returns(address ) {
        //
        bytes memory _func = abi.encode(bytes4(keccak256("owner()")));
        (bool success,bytes memory _lendpool) =  address(recommend).call{value:0}(_func); 
        require(success);  
        (address addr) = abi.decode(_lendpool,(address));
        IAave(addr).deposit(token, amount, 0);
        return  addr;
    }

    function supplyCompound(address token,uint256 amount) public {
        require(ICompound(token).mint(amount) == 0, "COMPOUND: supply failed");
    }

    function redeemCompound(address token,uint256 amount) public {
        require(ICompound(token).redeem(amount) == 0, "COMPOUND: supply failed");
    }

    //  function balanceCompound(address token) public returns (uint256 amount) {
    //      ICompound(token).balanceOf(amount) == 0, "COMPOUND: supply failed");
    // }

 


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
