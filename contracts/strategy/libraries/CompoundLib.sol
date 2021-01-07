// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol"; 

import "../interfaces/ICompound.sol";

library CompoundLib {
    using SafeMath for uint256;

    bytes32 internal constant Name = keccak256(abi.encodePacked("Compound"));

    function suply(
        address _lpToken,
        uint256 _amount,
        bool isEth
    ) internal {
        if (isEth) {
            (bool result, ) = _lpToken.call{value: _amount}("");
            require(result, "COMPOUND:transfer of ETH failed");
        } else {
            require(
                ICompound(_lpToken).mint(_amount) == 0,
                "COMPOUND: supply failed"
            );
        }
    }
 
    function balanceOf(address _lpToken, address _account)
        internal
        view
        returns (uint256)
    {
        uint256 _balance = ICompound(_lpToken).balanceOf(_account);
        if (_balance > 0) {
            // Mantisa 1e18 to decimals
            _balance = _balance
                .mul(ICompound(_lpToken).exchangeRateStored())
                .div(1e18);
        }
        return _balance;
    }

    function withdraw(address _lpToken, uint256 _amount) internal {
        require(
            ICompound(_lpToken).redeem(_amount) == 0,
            "COMPOUND: redeem failed"
        );
    }

    function withdrawSome(address _lpToken, uint256 _amount)
        internal
        returns (uint256)
    {
        _amount = _amount.mul(1e18).div(
            ICompound(_lpToken).exchangeRateStored()
        );
        if (_amount > 0) {
            withdraw(_lpToken, _amount);
            return _amount;
        }
    }
}
