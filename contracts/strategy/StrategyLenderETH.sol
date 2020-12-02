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


// interface IAaveAPR {
//     function getAaveCore() external view returns (address);
//     function getAave() external view    returns (address);
// }

contract StrategyLenderETH is IStrategy {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

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

    // 0xe0C86ECc6CC63154dE2459be1a36A6971bAa8d1C
    // 0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108 //dai
    // 0x3544e9b8B0f9Ce4dD01B2C89700BdC9FE22e09aa
    // https://ropsten.etherscan.io/tx/0x9fd4287d506126c9bdd49ff11b8a8f0bf6186acdd09e611679b3b64982bf079b
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
           if (name == Aave) {
                address _coreAddr = IAPR(_lender).getController(true);
                IERC20(want).safeIncreaseAllowance(_coreAddr, _balance);
                _supplyAave(want,_balance);
                return;
           }

           if (name == Compound) {
               //接受资产的合约地址
                address _lpToken = IAPR(_lender).getLpToken(want);
                // 拥有资产的合约, 将想要的 ERC20资产, 授权 LP 资产的代理额度.然后才能充值。
                IERC20(want).safeIncreaseAllowance(_lpToken, _balance);
                _supplyCompound(_lpToken,_balance);
                return;
           }
        }
        emit UnDepoist(_lenderName,_lender);
     }

    // _reserve  underlying asset
    function _supplyAave(address _token,uint256 amount) internal  {
        address _lender=address(recommend.lender);
        //获取能充值的地址
        address _lendpool = IAPR(_lender).getController(false);
        IAave(_lendpool).deposit(_token, amount, 0);
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

    function _supplyCompound(address _lpToken,uint256 amount) internal {
        require(ICompound(_lpToken).mint(amount) == 0, "COMPOUND: supply failed");
    }


    function redeemCompound(address lpToken,uint256 amount) public {
        require(ICompound(lpToken).redeem(amount) == 0, "COMPOUND: redeem failed");
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

    function balanceOf() override(IStrategy) external view returns (uint){
        return  balance().add(balanceRecommend());
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
