/**
 *Submitted for verification at Etherscan.io on 2020-02-12 v2
 https://etherscan.io/address/0x83f798e925bcd4017eb265844fddabb448f1707d#code
 没有 Redeem 需要自己 rebalance
*/

pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/EnumerableMap.sol";
import "./AddressStorage.sol";
import "../interfaces/ILenderProvider.sol";
import "../interfaces/ILender.sol";


contract LenderProvider is Ownable, ILenderProvider, AddressStorage {
    using Address for address;


    address public compound;
    address public aave;

    Lender public provider = Lender.NONE;
    constructor ()   {
        aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
        // Compound USDT -》cUSDT
        compound = address(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);
        //  approveToken();
    }

    //
    function getLenderApr(_lender) public view returns (address) {
        return getAddress(LENDING_POOL);
    }

    //获得推荐的 Lender
    function recommend(address _token) external returns (LenderInfo  memory){
        LenderInfo _lend = LenderInfo({lenderTokenAddr : 0x6B175474E89094C44Da98b954EedeAC495271d0F, apr : 1});
        return _lend;
    }

    //获得所有Lender的apr
    function recommendAll(address _token) external returns (LenderInfo []  memory){
        LenderInfo [] _lendAll;
        LenderInfo _lend = LenderInfo({lenderTokenAddr : 0x6B175474E89094C44Da98b954EedeAC495271d0F, apr : 1});
        _lendAll.push(_lend);
        return _lendAll;
    }

    //增加借贷人
    function addLender(address _lender) public onlyOwner {
        bytes32 _name = ILender(_lender);
        _setAddress(_name, _lender);
        emit LendingPoolUpdated(_pool);
    }

    //删除借贷人
    function delLender(address _pool) public onlyOwner {
        updateImplInternal(LENDING_POOL, _pool);
        emit LendingPoolUpdated(_pool);
    }


}
