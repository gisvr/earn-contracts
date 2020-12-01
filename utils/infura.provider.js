const {contract} = require("@openzeppelin/test-environment");
let network = "ropsten" //   rinkeby
const {projectId, privateKeys, adminKey} = require('/Users/liyu/Desktop/key/secrets.json');
let host = `https://${network}.infura.io/v3/${projectId}`
let Web3 = require("web3")
const web3 = new Web3(host)
let accounts = []
privateKeys.map(val => {
    let account = web3.eth.accounts.wallet.add(val)
    accounts.push(account)
})

module.exports = {
     getArttifact(name) {
         loadArtifact
        const arttifact = contract.fromArtifact(name)
        let [owner, user1, user2] = accounts
        arttifact.setProvider(web3.currentProvider)
        arttifact.defaults({
            from: owner.address,
            defaultGas: 8e6,
            defaultGasPrice: 20e9
        });

        return arttifact;
    },
    getAccounts() {
        return accounts
    }
}
