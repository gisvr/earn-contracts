// const Erc20 =  artifacts.require('Erc20');
const Migrations = artifacts.require("Migrations");

module.exports = async (deployer, network, accounts) => {
    let [ admin,user1,user2] = accounts;
    // console.log(admin,user1,user2);
    await deployer.deploy(Migrations,{from:user1});
};
