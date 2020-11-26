// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "../strategy/apr/interfaces/IAPR.sol"; 

contract MockAPR is IAPR { 
    string public lenderName;
    constructor(string memory _name) public{
        lenderName = _name;
    }

    function name() public override view returns (string memory){
        return lenderName;
    }

    function getAPR(address token) public  override view returns (uint256) {
        return 6;
    }

    // 调整收益率 - 可操作的量
    function getAPRAdjusted(address token, uint256 _supply) public  override view returns (uint256){
        return 12;
    }
}
 