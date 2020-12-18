
let host = "http://39.102.101.142:8545";
let Web3 = require("web3")
const web3 = new Web3(host)
let accounts = []

let contract = require("@truffle/contract");

let getArttifact = async (name,account,path,isAt) =>{
    let _art = require(path);
    let arttifact   = contract(_art)
    arttifact.setProvider(web3.currentProvider);
    arttifact.setWallet(web3.eth.accounts.wallet);
    arttifact.defaults({
        from: account,
        gas: 8e6,
        gasPrice: 20e9
    });
    let _chainId = await web3.eth.getChainId();
    if (_art.networks[_chainId]&&isAt) {
        arttifact =await arttifact.at(_art.networks[_chainId].address);
    }
    return arttifact;
}

module.exports = {
    async getArttifact(name,isAt=true) {
        accounts = await web3.eth.getAccounts();
        let path = "/Users/liyu/github/mars/earn-contracts/build/contracts/" + name + ".json";
        return getArttifact(name,accounts[0],path,isAt);
    },
    async getAave(name,isAt=true){
        accounts = await web3.eth.getAccounts();
        let path = "/Users/liyu/github/mars/aave-protocol/build/contracts/" + name + ".json";
        return getArttifact(name,accounts[0],path,isAt);
    },
    getAccounts() {
        return accounts
    },
    getWeb3() {
        return web3
    }
}
