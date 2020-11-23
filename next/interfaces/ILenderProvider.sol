
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


interface ILenderProvider  {
    struct LenderInfo {
        address lenderTokenAddr;
        uint256 apr;
    }

    // 获得最佳年化
    function recommend(address _token) external returns (LenderInfo  memory);
    // 获得所有年化收益
    function recommendAll(address _token) external returns (LenderInfo[]  memory);
}
