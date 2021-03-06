// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "../interfaces/IStrategy.sol";
import "../interfaces/ILenderAPR.sol";
import "../interfaces/IController.sol";

import "./apr/interfaces/IAPR.sol";
import "./apr/interfaces/ICompound.sol";

import "./libraries/CompoundLib.sol";
import "./libraries/AaveLib.sol";

contract StrategyLender is Ownable, IStrategy {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint256;
  using AaveLib for AaveLib.Aave;

  event Depoist(string name, address indexed lpAddres, uint256 balance);

  address public want;
  address public eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; //  address(0);
  address public controller;
  address public apr;
  ILenderAPR.Lender public recommend;

  constructor(
    address _want,
    address _controller,
    address _apr
  ) public {
    want = _want;
    controller = _controller;
    apr = _apr;
  }

  modifier onlyController() {
    require(msg.sender == controller, "Ownable: caller is not the controller");
    _;
  }

  function getWant() external view override returns (address) {
    return want;
  }

  function _rebalance() internal {
    ILenderAPR.Lender memory _recommend = ILenderAPR(apr).recommend(want);
    // TODO del want token not supported strategy
    // if (recommend.apr == 0) {
    //     recommend = _recommend;
    // }

    address _lender = address(recommend.lender);
    if (_recommend.lender != _lender) {
      _redeem(balanceOf()); //redemm all
      recommend = _recommend;
    }
  }

  function deposit(uint256 amount) public payable override onlyController returns (uint256) {
    _rebalance();
    address _lender = address(recommend.lender);
    string memory _lenderName = recommend.name;
    uint256 _balance = balance();

    if (_balance > 0) {
      _balance = amount;
      bytes32 name = keccak256(abi.encodePacked(_lenderName));
      bool isEth = true;

      if (name == AaveLib.Name) {
        address _coreAddr = IAPR(_lender).getController(true);
        address _lendpool = IAPR(_lender).getController(false);

        AaveLib.Aave memory _aave = AaveLib.Aave(_lendpool, _coreAddr);
        if (want != eth) {
          IERC20(want).safeIncreaseAllowance(_coreAddr, _balance);
          isEth = false;
        }
        _aave.suply(want, _balance, isEth);
      }

      if (name == CompoundLib.Name) {
        address _lpToken = IAPR(_lender).getLpToken(want);
        if (want != eth) {
          IERC20(want).safeIncreaseAllowance(_lpToken, _balance);
          isEth = false;
        }
        CompoundLib.suply(_lpToken, _balance, isEth);
      }
    }
    emit Depoist(_lenderName, _lender, _balance);
    return _balance;
  }

  receive() external payable {}

  function balanceOf() public view override(IStrategy) returns (uint256) {
    address _lpToken = IAPR(recommend.lender).getLpToken(want);
    bytes32 _name = keccak256(abi.encodePacked(recommend.name));

    if (_name == AaveLib.Name) {
      return AaveLib.balanceOf(_lpToken, address(this));
    }

    if (_name == CompoundLib.Name) {
      return CompoundLib.balanceOf(_lpToken, address(this));
    }
  }

  function withdrawAll()
    public
    override(IStrategy)
    onlyController
    returns (uint256)
  {
    uint256 _balance = balanceOf();
    withdraw(_balance);
    return _balance;
  }

  function withdraw(uint256 _balance)
    public
    override(IStrategy)
    onlyController
  {
    address vault = IController(controller).getVault();
    uint256 bal = _redeem(_balance);
    if (want == eth) {
      (bool result, ) = address(vault).call{ value: bal }("");
      require(result, "transfer of ETH failed");
    } else {
      IERC20(want).safeTransfer(vault, bal);
    }
  }

  function _redeem(uint256 _balance) internal returns (uint256 _bal) {
    address lender = address(recommend.lender);
    string memory lenderName = recommend.name;

    if (_balance > 0) {
      address lpToken = IAPR(lender).getLpToken(want);
      bytes32 name = keccak256(abi.encodePacked(lenderName));
      if (name == AaveLib.Name) {
        _bal = AaveLib.withdraw(lpToken, _balance);
      }

      if (name == CompoundLib.Name) {
        _bal = CompoundLib.withdrawSome(lpToken, _balance);
      }
    }
  }

  function balance() public view returns (uint256) {
    if (want == eth) {
      return address(this).balance;
    } else {
      return IERC20(want).balanceOf(address(this));
    }
  }

  function claim() public {
    address _lender = address(recommend.lender);
    string memory _lenderName = recommend.name;
    bytes32 _name = keccak256(abi.encodePacked(_lenderName));
    if (_name == CompoundLib.Name) {
      address _controller = IAPR(_lender).getController(false);
      IComptroller(_controller).claimComp(address(this));
    }
  }

  function claimBalance() public view returns (uint256) {
    address _lender = address(recommend.lender);
    string memory _lenderName = recommend.name;
    bytes32 _name = keccak256(abi.encodePacked(_lenderName));
    if (_name == CompoundLib.Name) {
      //Comp
      address _controller = IAPR(_lender).getController(false);
      return IComptroller(_controller).compAccrued(address(this));
    }
  }

  function inCaseTokenGetsStuck(IERC20 _tokenAddress) public onlyOwner {
    uint256 qty = _tokenAddress.balanceOf(address(this));
    _tokenAddress.transfer(msg.sender, qty);
  }

  function inCaseETHGetsStuck() public onlyOwner {
    uint256 bal = address(this).balance;
    (bool result, ) = msg.sender.call{ value: bal }("");
    require(result, "transfer of ETH failed");
  }
}
