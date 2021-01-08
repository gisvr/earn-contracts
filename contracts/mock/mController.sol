// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../interfaces/IController.sol";

contract mController {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    address public controller; 

    function setEarnController(address _controller) public {
        controller = _controller;
    }

    function earn(address _token) public {
        address vault = IController(controller).getVault();
        address strategy = IController(controller).getStrategy(_token);

        (bool success, ) = address(vault).call(
            abi.encodeWithSignature(
                "vaultTransfer(address,address)",
                _token,
                strategy 
            )
        ); 
        require(success, "earn call failed"); 
        IController(controller).earn(_token);
    }
 
    function withdraw(address _token, uint256 _amount) external {
        IController(controller).withdraw(_token, _amount);
    }
}
