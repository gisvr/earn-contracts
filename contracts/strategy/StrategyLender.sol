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
      
     function deposit() public override(IStrategy){
        (ILenderAPR.Lender memory _lender) = ILenderAPR(apr).recommend(want);
        recommend =address(_lender.lender); 

        string memory _lenderName= _lender.name;

        uint256 _balance = IERC20(want).balanceOf(address(this));
        if(_balance>0){
            //接受资产的合约地址
           (address _lpToken) = IAPR(recommend).getLpToken(want);
 
           bytes32 name = keccak256(abi.encodePacked(_lenderName));
           if (name == keccak256(abi.encodePacked("AAVE"))) { 
                bytes memory _core = abi.encode(bytes4(keccak256("getAaveCore()")));
                (bool success,bytes memory _coreByte) =  address(recommend).call{value:0}(_core); 
                require(success);  
                (address _coreAddr) = abi.decode(_coreByte,(address));

                IERC20(want).safeIncreaseAllowance(_coreAddr, _balance);
                supplyAave(_lpToken,_balance);
                
                emit Depoist("AA",_coreAddr,_balance);
                return ;
           } 

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
    
    function depositTest(uint256 amount) public  returns(ILenderAPR.Lender memory  lender) { 
        (ILenderAPR.Lender memory _lender) = ILenderAPR(apr).recommend(want);
        recommend =address(_lender.lender);
        (address _lpAddres) = IAPR(recommend).getLpToken(recommend);
        

        uint _balance = IERC20(want).balanceOf(address(this));
 
        if(_balance>0){
            //接受资产的合约地址
            // address _lpAddres = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
            //拥有资产的合约, 将想要的 ERC20资产, 授权 LP 资产的代理额度
            IERC20(want).safeIncreaseAllowance(_lpAddres, _balance);
             // 将合约的ERC20资产转入 LP 中，获得LP资产
            supplyCompound(want,_balance);
        }

        return _lender;
       
    }

    function supplyAave(address lptoken,uint256 amount) public  { 
        //获取能充值的地址
        bytes memory _aave = abi.encode(bytes4(keccak256("getAave()")));
        (bool success,bytes memory _lendpoolByte) =  address(recommend).call{value:0}(_aave); 
        require(success);  
        (address _lendpool) = abi.decode(_lendpoolByte,(address));
        IAave(_lendpool).deposit(lptoken, amount, 0); 
    }

    function supplyAaveTest(address token,uint256 amount) public returns(address ) {
        //获取能充值的地址
        bytes memory _core = abi.encode(bytes4(keccak256("getAaveCore()")));
        (bool isOk,bytes memory _coreByte) =  address(recommend).call{value:0}(_core); 
        require(isOk);  
        (address _coreAddr) = abi.decode(_coreByte,(address));


        //获取能充值的地址
        bytes memory _aave = abi.encode(bytes4(keccak256("getAave()")));
        (bool success,bytes memory _lendpoolByte) =  address(recommend).call{value:0}(_aave); 
        require(success);  
        (address _lendpool) = abi.decode(_lendpoolByte,(address));
        IAave(_lendpool).deposit(token, amount, 0);
        return  _lendpool;
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
