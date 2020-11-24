/**
 *Submitted for verification at Etherscan.io on 2020-02-06
*/

pragma solidity ^0.6.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface Compound {
    function mint(uint256 mintAmount) external returns (uint256);

    function redeem(uint256 redeemTokens) external returns (uint256);

    function exchangeRateStored() external view returns (uint);

    //---------------- oracle ------------
    function interestRateModel() external view returns (address);

    function reserveFactorMantissa() external view returns (uint256);

    function totalBorrows() external view returns (uint256);

    function totalReserves() external view returns (uint256);

    function supplyRatePerBlock() external view returns (uint);

    function getCash() external view returns (uint256);
}

interface InterestRateModel {
    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
}

contract CompoundAPR is Ownable {
    using SafeMath for uint256;
    using Address for address;

    uint256 DECIMAL = 10 ** 18;
 

    uint256 public liquidationRatio;
    uint256 public dydxModifier;
    uint256 public blocksPerYear = 2102400; // 1年的秒数/ 15秒出块 = 31536000/15

    /*
        get APR
    */

    function getCompoundAPR(address token) public view returns (uint256) {
        // * @notice返回此cToken的当前每块供应利率
        //* @返回每块的供应利率，按1e18缩放
        return Compound(token).supplyRatePerBlock().mul(2102400);
    }

    // 调整收益率 - 可操作的量
    function getCompoundAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
        Compound c = Compound(token);
        // * @notice返回此cToken的当前每块供应利率
        //* @返回每块的供应利率，按1e18缩放
        address model = Compound(token).interestRateModel();
        if (model == address(0)) {
            return c.supplyRatePerBlock().mul(2102400);
        }
        InterestRateModel i = InterestRateModel(model);
        //* @notice将此cToken的现金余额计入标的资产
        //* @返还本合同所拥有的标的资产数量
        uint256 cashPrior = c.getCash().add(_supply);

        //    * @notice计算每段现时的供应利率

        //    * @param现金市场拥有的现金总额
        //    * @param借款市场上未偿还的借款总额
        //    * @param储备金市场拥有的储备金总额
        //    * @param储备因数是市场现有的储备因数

        //    * @返回每个区块的供货率(以百分比表示，按1e18缩放)
        return i.getSupplyRate(cashPrior, c.totalBorrows(), c.totalReserves().add(_supply), c.reserveFactorMantissa()).mul(2102400);
    }
}
