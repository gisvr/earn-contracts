// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "../interfaces/IStrategy.sol";
import "../interfaces/ILenderAPR.sol";

// import "../interfaces/IDforce.sol"; 
// import "../interfaces/IController.sol";

import "./lender/interfaces/ICompound.sol";
import "./lender/interfaces/IAave.sol";
import "./apr/interfaces/IAPR.sol";

interface IAaveAPR {
    function getAaveCore() external view returns (address);
    function getAave() external view    returns (address);
}

contract StrategyLender is IStrategy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256; 

    event UnDepoist(string name,address indexed lpAddres);

    event Depoist(string name,address indexed lpAddres,uint256  balance);

    address public want;
    address public governance;
    address public controller;
    address public strategist;
    address public recommend = 0x540d7E428D5207B30EE03F2551Cbb5751D3c7569;
    address public apr; 

 

    constructor (address _controller, address _want,address _apr) public {
        want = address(_want);
        governance = msg.sender;
        strategist = msg.sender;
        controller = _controller;
        apr = _apr;
    }

// 0xe0C86ECc6CC63154dE2459be1a36A6971bAa8d1C
// 0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108 //dai
// 0x3544e9b8B0f9Ce4dD01B2C89700BdC9FE22e09aa
// https://ropsten.etherscan.io/tx/0x9fd4287d506126c9bdd49ff11b8a8f0bf6186acdd09e611679b3b64982bf079b
     function wantBalance() public   returns (uint256,address,address) {
        (ILenderAPR.Lender memory _lender) = ILenderAPR(apr).recommend(want);
        recommend =address(_lender.lender); 
 
        uint256 _balance =   IERC20(want).balanceOf(address(this));
        address _lpToken = IAPR(recommend).getLpToken(want);
        
        if(_balance>0){
           string memory _lenderName= _lender.name;
           bytes32 name = keccak256(abi.encodePacked(_lenderName));
           if (name == keccak256(abi.encodePacked("Aave"))) { 
                address _coreAddr = IAaveAPR(recommend).getAaveCore(); 
                IERC20(want).safeIncreaseAllowance(_coreAddr, _balance);
                // aave resver
                _supplyAave(want,_balance); 
                emit Depoist("AA",_coreAddr,_balance); 
           } 
        }

        return (_balance,recommend,_lpToken);
     }
     
     function wantBalance(address _recommend) public view returns ( string memory,uint256,address,address) { 
        (ILenderAPR.Lender memory _lender) = ILenderAPR(apr).recommend(want);
        address _lenderAddr =address(_lender.lender); 
        address _lpToken = IAPR(_lenderAddr).getLpToken(want);
        uint256 _balance =   IERC20(want).balanceOf(address(this)); 
        string memory _lenderName= _lender.name;
        
        bytes32 name = keccak256(abi.encodePacked(_lenderName));
           if (name == keccak256(abi.encodePacked("Aave"))) { 
                // _lpToken = IAaveAPR(_lenderAddr).getAaveCore(); 
           }
        // _lpToken = msg.sender;
        return  (_lenderName,_balance,_lenderAddr,_lpToken);
     } 

     function deposit() public override(IStrategy){
        (ILenderAPR.Lender memory _lender) = ILenderAPR(apr).recommend(want);
        recommend =address(_lender.lender); 

        string memory _lenderName= _lender.name;

        uint256 _balance = IERC20(want).balanceOf(address(this));
        if(_balance>0){
           bytes32 name = keccak256(abi.encodePacked(_lenderName));
           if (name == keccak256(abi.encodePacked("Aave"))) { 
                address _coreAddr = IAaveAPR(recommend).getAaveCore(); 
                IERC20(want).safeIncreaseAllowance(_coreAddr, _balance);
                _supplyAave(want,_balance); 
                return;
                // emit Depoist("AA",_coreAddr,_balance); 
           } 
           
            //接受资产的合约地址
           address _lpToken = IAPR(recommend).getLpToken(want); 
           // 拥有资产的合约, 将想要的 ERC20资产, 授权 LP 资产的代理额度.然后才能充值。    
           IERC20(want).safeIncreaseAllowance(_lpToken, _balance);
           if (name == keccak256(abi.encodePacked("Compound"))) { 
                emit Depoist("CC",_lpToken,_balance);
           } 
            
           // 将合约的ERC20资产转入 LP 中，获得LP资产
          
        } 
        emit UnDepoist(_lenderName,recommend); 
        //supplyCompound(want,_balance); 
     }

    // _reserve  underlying asset
    function _supplyAave(address token,uint256 amount) internal  { 
        //获取能充值的地址
        address _lendpool=IAaveAPR(recommend).getAave();
        IAave(_lendpool).deposit(token, amount, 0); 
    }

    function _balanceAave() public view returns (uint256) {
        address _lpToken = IAPR(recommend).getLpToken(want);
        return IERC20(_lpToken).balanceOf(address(this));
    }

     function withdrawAave() public  {
        uint256 _aaveBalance = _balanceAave();
        if(_aaveBalance>0){
            address _lpToken = IAPR(recommend).getLpToken(want);
            IAToken(_lpToken).redeem(_aaveBalance);
        } 
    }

    function withdraw(uint256 _aaveBalance) public override(IStrategy) {
        // uint256 _aaveBalance = _balanceAave();
        if(_aaveBalance>0){
            address _lpToken = IAPR(recommend).getLpToken(want);
            IAToken(_lpToken).redeem(_aaveBalance);
        } 
    }

    function _balance() public view returns (uint256) {
        return IERC20(want).balanceOf(address(this));
    }
 
    function supplyCompound(address lptoken,uint256 amount) public {
        require(ICompound(lptoken).mint(amount) == 0, "COMPOUND: supply failed");
    }

    function redeemCompound(address lptoken,uint256 amount) public {
        require(ICompound(lptoken).redeem(amount) == 0, "COMPOUND: supply failed");
    }

    //  function balanceCompound(address token) public returns (uint256 amount) {
    //      ICompound(token).balanceOf(amount) == 0, "COMPOUND: supply failed");
    // }

 


    function harvest() override(IStrategy) external {

    }

    function withdraw(address) override(IStrategy) external {

    }

   

    function withdrawAll() override(IStrategy) external returns (uint){
        return uint(1);
    }

    function balanceOf() override(IStrategy) external view returns (uint){
        return _balance()
        .add(_balanceAave());
    }

    // incase of half-way error
    function inCaseTokenGetsStuck(IERC20 _TokenAddress)   public {
        uint qty = _TokenAddress.balanceOf(address(this));
        _TokenAddress.transfer(msg.sender, qty);
    }
   // incase of half-way error
    function inCaseETHGetsStuck()   public {
        uint256 _bal = address(this).balance;
        (bool result,) =  msg.sender.call{value:_bal}("");
        require(result, "transfer of ETH failed");
    }
 
}
