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
    address  Compound; 
    address cETH = 0xBe839b6D93E3eA47eFFcCA1F27841C917a8794f3; // ropsten

    //0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B 
    constructor(address _comptroller) public {
        Compound = _comptroller; 
    }
    
    function initialize(address _comptroller) public onlyOwner {
        Compound = _comptroller; 
    }
    
    function setCETH(address _cETH) public onlyOwner {
        cETH = _cETH; 
    }

    function name() public override view returns (string memory){
        return lenderName;
    }

    function getController(bool _core)  view  public override returns (address) {
        return Compound; 
    }
 
    function getLpToken(address token) public view override returns (address){
        // 0x0000000000000000000000000000000000000000
        address _lpToken = address(0);
        if(token == _lpToken){
            return cETH; 
        } 
        
        (address[] memory _cTokens) = IComptroller(Compound).getAllMarkets();
        for(uint i = 0; i < _cTokens.length; i++) { 
            address _cToken = _cTokens[i];
            if(_cToken != cETH){
                (address _token) = ICToken(_cToken).underlying();
               if(_token == token){
                   return _cToken; 
               }
            } 
        }
        return _lpToken; 
    }

    /*
        get APR
    */ 
    function getAPR(address token) public override view returns (uint256) {
        address _lpToken =  getLpToken(token);
        // * @notice返回此cToken的当前每块供应利率
        //* @返回每块的供应利率，按1e18缩放
        return ICToken(_lpToken).supplyRatePerBlock().mul(blocksPerYear);
    }

    // 调整收益率 - 可操作的量
    function getAPRAdjusted(address token, uint256 _supply) public override view returns (uint256) {
         address _lpToken =  getLpToken(token);
        ICToken c = ICToken(_lpToken);
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
}
