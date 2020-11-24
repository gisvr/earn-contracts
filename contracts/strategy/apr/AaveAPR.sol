/**
 *Submitted for verification at Etherscan.io on 2020-02-06
 https://etherscan.io/address/0xeC3aDd301dcAC0e9B0B880FCf6F92BDfdc002BBc#code
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol"; 
import "./interfaces/IAave.sol";
import "./interfaces/IAPR.sol";


contract AaveAPR  is Ownable,IAPR {
    using SafeMath for uint256;
    using Address for address;
    address public AAVE; 

    // 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8 mainnet
    constructor(address _addressesProvider) public {
        AAVE = _addressesProvider; 
    }

    function getAaveCore() public view returns (address) {
        return address(ILendingPoolAddressesProvider(AAVE).getLendingPoolCore());
    }

    function initialize(address _addressesProvider) public onlyOwner {
        AAVE = _addressesProvider; 
    }

    /*
        get APR
    */ 
    function getAPR(address token) public override view returns (uint256) {
        address AaveCore = getAaveCore();
        ILendingPoolCore core = ILendingPoolCore(AaveCore);
        // 资产当前的流动性比率， 统一单位 到 e18 aave的单位是e27
        return core.getReserveCurrentLiquidityRate(token).div(1e9);
    }

    function getAPRAdjusted(address token, uint256 _supply) public override view returns (uint256) {
        address AaveCore = getAaveCore();
        ILendingPoolCore core = ILendingPoolCore(AaveCore);
        //获得资产的利率策略
        IReserveInterestRateStrategy apr = IReserveInterestRateStrategy(core.getReserveInterestRateStrategyAddress(token));
        //计算利率
        (uint256 newLiquidityRate,,) = apr.calculateInterestRates(
            token,
            core.getReserveAvailableLiquidity(token).add(_supply), // 可用的流动性
            core.getReserveTotalBorrowsStable(token), // 总共的固定利率借出
            core.getReserveTotalBorrowsVariable(token), // 总计浮动利率借出
            core.getReserveCurrentAverageStableBorrowRate(token) // 当前平均固定借出利率
        );
        // aave 的利率是 27位
        return newLiquidityRate.div(1e9);
    }

}
