
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./IStrategy.sol";

interface IControllerStrategy is IStrategy {
     function want() external view returns (address);
}
