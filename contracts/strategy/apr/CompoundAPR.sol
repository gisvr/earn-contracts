/**
 *Submitted for verification at Etherscan.io on 2020-02-06
 */
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/ICompound.sol";
import "./interfaces/IAPR.sol";

contract CompoundAPR is Ownable, IAPR {
    using SafeMath for uint256;
    uint256 public blocksPerYear = 2102400; // 1 year/ 15 seconds for per block = 31536000/15
    string public lenderName = "Compound";
    address public Compound;
    address eth =  0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address lpETH = 0xBe839b6D93E3eA47eFFcCA1F27841C917a8794f3; // ropsten

    constructor(address _comptroller) public {
        Compound = _comptroller;
    }

    function initialize(address _comptroller) public onlyOwner {
        Compound = _comptroller;
    }

    function setETH(address _cETH) public onlyOwner {
        lpETH = _cETH;
    }

    function name() public view override returns (string memory) {
        return lenderName;
    }

    function getController(bool _core) public view override returns (address) {
        require(!_core, "is ok");
        return Compound;
    }

    function getLpToken(address _token) public view override returns (address) {
        address _lpToken = eth;
        if (_token == _lpToken) {
            return lpETH;
        }

        address[] memory _cTokens = IComptroller(Compound).getAllMarkets();
        for (uint256 i = 0; i < _cTokens.length; i++) {
            address _cToken = _cTokens[i];
            if (_cToken != lpETH) {
                address _underlyingToken = ICToken(_cToken).underlying();
                if (_underlyingToken == _token) {
                    return _cToken;
                }
            }
        }
        return _lpToken;
    }

    function getAPR(address _token) public view override returns (uint256) {
        address _lpToken = getLpToken(_token);
        if (_lpToken == eth) {
            return 0;
        }
        return ICToken(_lpToken).supplyRatePerBlock().mul(blocksPerYear);
    }

    function getAPRAdjusted(address _token, uint256 _supply)
        public
        view
        override
        returns (uint256)
    {
        address _lpToken = getLpToken(_token);
        ICToken c = ICToken(_lpToken);
        address _model = ICToken(_token).interestRateModel();
        if (_model == eth) {
            return c.supplyRatePerBlock().mul(blocksPerYear);
        }
        IInterestRateModel i = IInterestRateModel(_model);
        uint256 cashPrior = c.getCash().add(_supply);
        return
            i
                .getSupplyRate(
                cashPrior,
                c.totalBorrows(),
                c.totalReserves().add(_supply),
                c.reserveFactorMantissa()
            )
                .mul(blocksPerYear);
    }
}
