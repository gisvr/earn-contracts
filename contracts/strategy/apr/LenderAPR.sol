/**
 *Submitted for verification at Etherscan.io on 2020-02-06
 https://etherscan.io/address/0xeC3aDd301dcAC0e9B0B880FCf6F92BDfdc002BBc#code
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../../interfaces/ILenderAPR.sol";
import "./interfaces/IAPR.sol";

contract LenderAPR is Ownable, ILenderAPR {
    using SafeMath for uint256;
    using Address for address;

    Lender[] public lenders;

    function recommend(address token)
        public
        view
        override
        returns (Lender memory)
    {
        Lender[] memory _lenders = lenders;
        uint256 _max = 0;
        uint256 _index = 0;
        for (uint256 i = 0; i < lenders.length; i++) {
            uint256 _apr = IAPR(lenders[i].lender).getAPR(token);
            if (_max < _apr) {
                _max = _apr;
                _index = i;
            }
        }
        _lenders[_index].apr = _max;
        return _lenders[_index];
    }

    function recommendAll(address token)
        public
        view
        override
        returns (Lender[] memory)
    {
        Lender[] memory _lenders = lenders;
        for (uint256 i = 0; i < _lenders.length; i++) {
            _lenders[i].apr = IAPR(_lenders[i].lender).getAPR(token);
        }
        return _lenders;
    }

    function lendersLength() public view returns (uint256) {
        return lenders.length;
    }

    function addLender(string memory name, address lenderApr) public onlyOwner {
        lenders.push(Lender({name: name, lender: lenderApr, apr: 1}));
    }

    function removeLender(uint8 index) public onlyOwner {
        if (index >= lenders.length) return;
        lenders[index] = lenders[lenders.length - 1];
        lenders.pop();
    }
}
