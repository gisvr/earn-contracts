// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ILenderAPR {
    struct Lender {
        string name;
        address lender;
        uint256 apr;
    }

    function recommend(address) external view returns (Lender memory);

    function recommendAll(address) external view returns (Lender[] memory);
}
