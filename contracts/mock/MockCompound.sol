// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "./MockERC20.sol"; 

import "../strategy/apr/interfaces/ICompound.sol"; 

contract CToken is  MockERC20,ICToken {
    address public modelAddress; 
    address token;

    constructor (string memory name, string memory symbol, uint256 initialSupply, uint8 decimals) 
      MockERC20( name, symbol, initialSupply, decimals) public {
         
    }
    
    function interestRateModel() public override(ICToken) view returns (address){
        return modelAddress;
    }

    function setInterestRateModel(address _modelAddress) public{
          modelAddress = _modelAddress;
    }

    // // (token,cToken)
    //     addCToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    //     // cDAI 

    function reserveFactorMantissa() public override(ICToken) view returns (uint256){ return 1;}

    function totalBorrows()  public override(ICToken) view returns (uint256){ return 1;}

    function totalReserves()  public override(ICToken) view returns (uint256){ return 1;}

    function supplyRatePerBlock() public override(ICToken) view returns (uint ){ return 1;}

    function getCash()  public override(ICToken) view returns (uint256){ return 1;}
}

contract InterestRateModel is IInterestRateModel {
    function getSupplyRate(
        uint cash, 
        uint borrows, 
        uint reserves, 
        uint reserveFactorMantissa
    ) public override view returns (uint){ return 1;}
}