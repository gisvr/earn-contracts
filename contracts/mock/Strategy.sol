// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "../interfaces/IStrategy.sol";
//import "../interfaces/IController.sol";

contract Strategy is IStrategy {
    address public wantAddr;
    constructor(address _wantAddr) public  {
        wantAddr = _wantAddr;
    }
    function want() override(IStrategy) external view returns (address){
        return wantAddr;
    }

    function deposit() override(IStrategy) external {

    }

    function withdraw(address) override(IStrategy) external {

    }

    function withdraw(uint) override(IStrategy) external {

    }

    function withdrawAll() override(IStrategy) external returns (uint){
        return uint(1);
    }

    function balanceOf() override(IStrategy) external view returns (uint){
        return uint(0);
    }
}
