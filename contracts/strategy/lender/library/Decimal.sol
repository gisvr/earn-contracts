pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

library Decimal {
    using SafeMath for uint256;

    uint256 constant BASE = 10 ** 18;

    function one()
    internal
    pure
    returns (uint256)
    {
        return BASE;
    }

    function onePlus(
        uint256 d
    )
    internal
    pure
    returns (uint256)
    {
        return d.add(BASE);
    }

    function mulFloor(
        uint256 target,
        uint256 d
    )
    internal
    pure
    returns (uint256)
    {
        return target.mul(d) / BASE;
    }

    //https://github.com/ripio/ramp-contracts/blob/master/contracts/utils/Math.sol
    function divCeil(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
        require(_b != 0, "div by zero");
        c = _a / _b;
        if (_a % _b != 0) {
            c = c + 1;
        }
        return c;
    }

    function mulCeil(
        uint256 target,
        uint256 d
    )
    internal
    pure
    returns (uint256)
    {
        // return target.mul(d).divCeil(BASE);
        return divCeil(target.mul(d), BASE);
    }

    function divFloor(
        uint256 target,
        uint256 d
    )
    internal
    pure
    returns (uint256)
    {
        return target.mul(BASE).div(d);
    }

}
