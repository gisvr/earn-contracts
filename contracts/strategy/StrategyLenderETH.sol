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
import "./apr/interfaces/ICompound.sol";
import "./lender/CompoundLib.sol";
import "./lender/AaveLib.sol";
 
contract StrategyLenderETH is IStrategy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    using AaveLib for AaveLib.Aave;

    event UnDepoist(string name,address indexed lpAddres);

    event Depoist(string name,address indexed lpAddres,uint256  balance);

    address public want;
    address public governance;
    address public controller;
    address public strategist;
    address public apr;
    bytes32 public Aave = keccak256(abi.encodePacked("Aave"));
    bytes32 public Compound = keccak256(abi.encodePacked("Compound"));
    ILenderAPR.Lender public recommend;

    constructor (address _controller,address _apr) public {
        want = address(0);
        governance = msg.sender;
        strategist = msg.sender;
        controller = _controller;
        apr = _apr;
    } 

     function rebalance() internal{
        ILenderAPR.Lender memory _recommend = ILenderAPR(apr).recommend(want);
        if(recommend.apr==0){
            recommend = _recommend;
        }

        address _lender=address(recommend.lender);
        if(_recommend.lender != _lender){
             withdrawAll(); // 移仓
             recommend = _recommend;
        }
     }

     function deposit() public override(IStrategy){
        rebalance();
        address _lender=address(recommend.lender);
        string memory _lenderName= recommend.name;
        uint256 _balance =  balance();
        if(_balance>0){
            // 将合约的ERC20资产转入 LP 中，获得LP资产
           bytes32 name = keccak256(abi.encodePacked(_lenderName));
           if (name == AaveLib.Name) {
                address _coreAddr = IAPR(_lender).getController(true);
                address _lendpool = IAPR(_lender).getController(false);  
                AaveLib.Aave memory _aave = AaveLib.Aave(_lendpool,_coreAddr);  
                _aave.suply(want,_balance); 
                return;
           }

           if (name == CompoundLib.Name) {
               //接受资产的合约地址
                address _lpToken = IAPR(_lender).getLpToken(want);
                // 拥有资产的合约, 将想要的 ERC20资产, 授权 LP 资产的代理额度.然后才能充值。
                IERC20(want).safeIncreaseAllowance(_lpToken, _balance);
                CompoundLib.suply(_lpToken,_balance);
                return;
           }
        }
        emit UnDepoist(_lenderName,_lender);
     }

     function balanceOf() override(IStrategy) public view returns (uint){
        address _lpToken = IAPR(recommend.lender).getLpToken(want);
        bytes32 name = keccak256(abi.encodePacked(recommend.name));
         
        if (name == AaveLib.Name) {
           return  IAToken(_lpToken).balanceOf(address(this));
        }

        if (name == CompoundLib.Name) {   
           return  CompoundLib.balanceOf(_lpToken,address(this));
        }
        
        return IERC20(_lpToken).balanceOf(address(this));
    }
 

    //Recommend 的余额
    function  balanceRecommend() public view returns (uint256) {
        address _lender=address(recommend.lender);
        address _lpToken = IAPR(_lender).getLpToken(want);
        return IERC20(_lpToken).balanceOf(address(this));
    }

    function withdrawAll() override(IStrategy) public returns (uint){
        uint256 _balance = balanceRecommend();
        withdraw(_balance);
        return _balance;
    }

    function withdraw(uint256 _balance) public override(IStrategy) {
        address _lender=address(recommend.lender);
        string memory _lenderName= recommend.name;

        if(_balance>0){
            address _lpToken = IAPR(_lender).getLpToken(want);
            bytes32 name = keccak256(abi.encodePacked(_lenderName));
           if (name ==  Aave) {
                IAToken(_lpToken).redeem(_balance);
                return;
           }

           if (name == Compound) {
                require(ICompound(_lpToken).redeem(_balance) == 0, "COMPOUND: redeem failed");
                return;
           }
        }
    }

    function balance() public view returns (uint256) {
        return IERC20(want).balanceOf(address(this));
    }
 
    function claimComp() public {
       address _lender=address(recommend.lender);
       string memory _lenderName= recommend.name;
       bytes32 name = keccak256(abi.encodePacked(_lenderName));
        if (name == Compound) {
            address _controller = IAPR(_lender).getController(false);
            IComptroller(_controller).claimComp(address(this));
        }
    }

    function compBalance() public view returns (uint256 ) {
       address _lender=address(recommend.lender);
       string memory _lenderName= recommend.name;
       bytes32 name = keccak256(abi.encodePacked(_lenderName));
        if (name == Compound) {
            address _controller = IAPR(_lender).getController(false);
            return IComptroller(_controller).compAccrued(address(this));
        }else{
            return 0;
        }
    }


    function harvest() override(IStrategy) external {

    }

    function withdraw(address) override(IStrategy) external {

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
