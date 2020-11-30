let network = "ropsten" //   rinkeby 
const {projectId,privateKeys, adminKey} = require('/Users/liyu/Desktop/key/secrets.json');
let Web3 = require("web3")

let host = `https://${network}.infura.io/v3/${projectId}`


// require('@openzeppelin/test-helpers/configure')({
//     provider: host,
//     singletons: {
//         abstraction: 'truffle',
//     },
// });


const {
    BN,           // Big Number support
    constants,
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const {setupLoader} = require('@openzeppelin/contract-loader');
const loader = setupLoader({
    provider: host,
    defaultGas: 8e6,
    defaultGasPrice: 20e9
}).truffle;

const AaveAPR = loader.fromArtifact("AaveAPR")
const LenderAPR = contract.fromArtifact("LenderAPR");

module.exports = {
    async getArttifact() {
        const web3 = new Web3(host)  
        let accounts = []
        privateKeys.map(val => {
            let account = web3.eth.accounts.wallet.add(val)
            accounts.push(account.address)
        })
        let wallet = web3.eth.accounts.wallet 
        let [owner] = accounts 
        
        AaveAPR.setWallet(wallet).defaults({ from: owner });
        LenderAPR.setWallet(wallet).defaults({ from: owner });

        return {
            BN,
            web3,
            constants,
            accounts,
            AaveAPR,
            LenderAPR,
        }
    }
}
