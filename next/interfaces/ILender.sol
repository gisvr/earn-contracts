pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ILender {
    // Lender  名称
    function name() external returns (string name);
    // 控制地址
    function controlAddress() external returns (string addr);

    // depoist
}
