pragma solidity ^0.6.0;

interface IStrategy {
    function deposit() external payable;

    function withdraw(uint256) external;

    function withdrawAll() external returns (uint256);

    function balanceOf(address _want) external view returns (uint256);
}
