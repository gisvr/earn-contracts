/**
 *Submitted for verification at Etherscan.io on 2020-02-12 v2
 https://etherscan.io/address/0x83f798e925bcd4017eb265844fddabb448f1707d#code
 没有 Redeem 需要自己 rebalance
*/

pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";


import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "../manager/EarnManager.sol";

contract mUSDT is ERC20, ERC20Detailed, ReentrancyGuard, Ownable, Structs {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    uint256 public pool;
    address public token;
    address public compound;
    address public fulcrum;
    address public aave;
    address public aaveToken;
    address public dydx;
    uint256 public dToken;
    address public apr;

    enum Lender {
        NONE,
        DYDX,
        COMPOUND,
        AAVE,
        FULCRUM
    }

    Lender public provider = Lender.NONE;

    constructor () public ERC20Detailed("mint earn USDT", "mUSDT", 6) {
        //Tether USD USDT
        token = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        // IEarnAPRWithPool
        apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
    }

    function initialize(LendingPoolAddressesProvider _addressesProvider) public initializer {
        addressesProvider = _addressesProvider;
        core = LendingPoolCore(addressesProvider.getLendingPoolCore());
        dataProvider = LendingPoolDataProvider(addressesProvider.getLendingPoolDataProvider());
        parametersProvider = LendingPoolParametersProvider(
            addressesProvider.getLendingPoolParametersProvider()
        );
        feeProvider = IFeeProvider(addressesProvider.getFeeProvider());
    }

    // Ownable setters incase of support in future for these systems
    function set_new_APR(address _new_APR) public onlyOwner {
        apr = _new_APR;
    }
}
