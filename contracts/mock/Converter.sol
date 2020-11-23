// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "../interfaces/IConverter.sol";
//import "../interfaces/IController.sol";

contract Converter is IConverter {

    function convert(address) override(IConverter) external returns (uint){
        return 0;
    }

}
