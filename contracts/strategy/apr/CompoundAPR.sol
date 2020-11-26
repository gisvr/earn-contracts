/**
 *Submitted for verification at Etherscan.io on 2020-02-06
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ICompound.sol";
import "./interfaces/IAPR.sol";
contract CompoundAPR is Ownable,IAPR {
    using SafeMath for uint256;
    using Address for address; 
    uint256 public blocksPerYear = 2102400; // 1年的秒数/ 15秒出块 = 31536000/15
    string public lenderName = "Compound";

    function name() public override view returns (string memory){
        return lenderName;
    }

    function getLpToken(address token) public  override view returns (address){
        return token; 
    }

    /*
        get APR
    */ 
    function getAPR(address token) public override view returns (uint256) {
        // * @notice返回此cToken的当前每块供应利率
        //* @返回每块的供应利率，按1e18缩放
        return ICToken(token).supplyRatePerBlock().mul(blocksPerYear);
    }

    // 调整收益率 - 可操作的量
    function getAPRAdjusted(address token, uint256 _supply) public override view returns (uint256) {
        ICToken c = ICToken(token);
        // * @notice返回此cToken的当前每块供应利率
        //* @返回每块的供应利率，按1e18缩放
        address model = ICToken(token).interestRateModel();
        if (model == address(0)) {
            return c.supplyRatePerBlock().mul(2102400);
        }
        IInterestRateModel i = IInterestRateModel(model);
        //* @notice将此cToken的现金余额计入标的资产
        //* @返还本合同所拥有的标的资产数量
        uint256 cashPrior = c.getCash().add(_supply);

        //    * @notice计算每段现时的供应利率

        //    * @param现金市场拥有的现金总额
        //    * @param借款市场上未偿还的借款总额
        //    * @param储备金市场拥有的储备金总额
        //    * @param储备因数是市场现有的储备因数

        //    * @返回每个区块的供货率(以百分比表示，按1e18缩放)
        return i.getSupplyRate(
            cashPrior, 
            c.totalBorrows(), 
            c.totalReserves().add(_supply), 
            c.reserveFactorMantissa()
        ).mul(blocksPerYear);
    }

    // function supply(address cToken,uint amount) public {
    //     require(ICToken(cToken).mint(amount) == 0, "COMPOUND: supply failed");
    // }

    // function balance(address cToken,address user) public view returns (uint256) {
    //     return IERC20(cToken).balanceOf(address(user));
    // }
}
