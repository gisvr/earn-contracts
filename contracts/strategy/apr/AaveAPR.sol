// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IAave.sol";
import "./interfaces/IAPR.sol";

contract AaveAPR is Ownable, IAPR {
    using SafeMath for uint256;
    address public Aave;
    string public lenderName = "Aave";
    address aETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor(address _provider) public {
        Aave = _provider;
    }

    function initialize(address _addressesProvider) public onlyOwner {
        Aave = _addressesProvider;
    }

    function setETH(address _ETH) public onlyOwner {
        aETH = _ETH;
    }

    function setAave(address _provider) public onlyOwner {
        Aave = _provider;
    }

    function getAaveCore() public view returns (address) {
        return
            address(ILendingPoolAddressesProvider(Aave).getLendingPoolCore());
    }

    function getAave() public view returns (address) {
        return address(ILendingPoolAddressesProvider(Aave).getLendingPool());
    }

    function getController(bool _core) public view override returns (address) {
        if (_core) {
            return getAaveCore();
        } else {
            return getAave();
        }
    }

    function name() public view override returns (string memory) {
        return lenderName;
    }

    function getLpToken(address _token) public view override returns (address) {
        _token == address(0) ? aETH : _token;
        return ILendingPoolCore(getAaveCore()).getReserveATokenAddress(_token);
    }

    function getAPR(address _token) public view override returns (uint256) {
        _token == address(0) ? aETH : _token;
        return
            ILendingPoolCore(getAaveCore())
                .getReserveCurrentLiquidityRate(_token)
                .div(1e9);
    }

    function getAPRAdjusted(address _token, uint256 _supply)
        public
        view
        override
        returns (uint256)
    {
        _token == address(0) ? aETH : _token;
        ILendingPoolCore core = ILendingPoolCore(getAaveCore());
        IReserveInterestRateStrategy apr =
            IReserveInterestRateStrategy(
                core.getReserveInterestRateStrategyAddress(_token)
            );
        (uint256 newLiquidityRate, , ) =
            apr.calculateInterestRates(
                _token,
                core.getReserveAvailableLiquidity(_token).add(_supply),
                core.getReserveTotalBorrowsStable(_token),
                core.getReserveTotalBorrowsVariable(_token),
                core.getReserveCurrentAverageStableBorrowRate(_token)
            );
        return newLiquidityRate.div(1e9);
    }
}
