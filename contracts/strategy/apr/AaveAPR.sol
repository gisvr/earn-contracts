// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IAave.sol";
import "./interfaces/IAPR.sol";


contract AaveAPR  is Ownable,IAPR {
    using SafeMath for uint256;
    address public  Aave;
    string public lenderName = "Aave";
    address  aETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
 
    constructor(address _provider) public {
        Aave = _provider;
    }

    function setETH(address _ETH) public onlyOwner {
        aETH = _ETH;
    }

    function setAave(address _provider) public onlyOwner {
        Aave = _provider;
    }

    function getAaveCore() public view returns (address) {
        return address(ILendingPoolAddressesProvider(Aave).getLendingPoolCore());
    }


    function getAave()  view  public returns (address) {
        return address(ILendingPoolAddressesProvider(Aave).getLendingPool());
    }

    function getController(bool _core)  view  public override returns (address) {
        if(_core){
            return getAaveCore();
        }else{
            return getAave();
        }
    }

    function initialize(address _addressesProvider) public onlyOwner {
        Aave = _addressesProvider;
    }

    function name() public override view returns (string memory){
        return lenderName;
    }

    function getEth(address _token) internal view  returns (address){
        if(_token == address(0)){
            _token = aETH;
        }
        return _token;
    }

    function getLpToken(address _token) public override view returns (address){
        _token = getEth(_token); 
       return ILendingPoolCore(getAaveCore()).getReserveATokenAddress(_token); 
    }

    function getAPR(address _token) public override view returns (uint256) {
        _token = getEth(_token);
        // 资产当前的流动性比率， 统一单位 到 e18 aave的单位是e27
        return ILendingPoolCore(getAaveCore()).getReserveCurrentLiquidityRate(_token).div(1e9);
    }

    function getAPRAdjusted(address _token, uint256 _supply) public override view returns (uint256) {
        _token = getEth(_token);
        ILendingPoolCore core = ILendingPoolCore(getAaveCore());
        //获得资产的利率策略
        IReserveInterestRateStrategy apr = IReserveInterestRateStrategy(core.getReserveInterestRateStrategyAddress(_token));
        //计算利率
        (uint256 newLiquidityRate,,) = apr.calculateInterestRates(
            _token,
            core.getReserveAvailableLiquidity(_token).add(_supply), // 可用的流动性
            core.getReserveTotalBorrowsStable(_token), // 总共的固定利率借出
            core.getReserveTotalBorrowsVariable(_token), // 总计浮动利率借出
            core.getReserveCurrentAverageStableBorrowRate(_token) // 当前平均固定借出利率
        );
        // aave 的利率是 27位
        return newLiquidityRate.div(1e9);
    }

}
