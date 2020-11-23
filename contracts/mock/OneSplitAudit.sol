// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "../interfaces/IOneSplitAudit.sol";
//import "../interfaces/IController.sol";

contract OneSplitAudit is IOneSplitAudit {
    string public name;
    constructor(string memory _name) public  {
        name = _name;
    }

    function swap(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution,
        uint256 flags
    )
    override(IOneSplitAudit)
    external
    payable
    returns (uint256 returnAmount){

        return 123;
    }

    function getExpectedReturn(
        address fromToken,
        address destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags // See constants in IOneSplit.sol // 1 - Uniswap, 2 - Kyber, 4 - Bancor, 8 - Oasis, 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken, 1024 - bDAI
    )
    override(IOneSplitAudit)
    external
    view
    returns (
        uint256 returnAmount,
        uint256[] memory distribution // [Uniswap, Kyber, Bancor, Oasis]
    ){
        uint256[] memory x = new uint256[](3);
        x[0] = 1;
        x[1] = 3;
        x[2] = 4;
        return (1,x);
    }

}
