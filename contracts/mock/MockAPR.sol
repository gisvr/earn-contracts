// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "../strategy/apr/interfaces/IAPR.sol"; 

contract MockAPR is IAPR { 
    string public lenderName;
    address public core;
    constructor(string memory _name,address _core) public{
        lenderName = _name;
        core= _core;
    }

    function getController(bool _core) public view override returns (address) {
        if(_core){
            
        }
        return core;
    }
    

     function getAaveCore() public view returns (address) {
        return core;
    }

    function getAave()  view  public returns (address) {
        return core;
    }


    function name() public  view override returns (string memory){
        return lenderName;
    }

    function getLpToken(address token) public view override returns (address){
          return token;
    }
 
    function getAPR(address token) public  override view returns (uint256) {
        return 6;
    }

    // 调整收益率 - 可操作的量
    function getAPRAdjusted(address token, uint256 _supply) public  override view returns (uint256){
        return 12;
    }
}
 