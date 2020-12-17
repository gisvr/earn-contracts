// const MockErc20 =  artifacts.require('MockErc20');
let nodeProvider = require("../../utils/ganache.provider");
const Migrations = artifacts.require("Migrations");

module.exports = async (deployer, network, accounts) => {
    let [ admin,user1,user2] = accounts;
    let _dai = await nodeProvider.getAave("MockDAI");

    console.log(_dai.address);
    await deployer.deploy(Migrations,{from:user1});
};
