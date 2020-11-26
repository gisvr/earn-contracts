const provider = require("../utils/base/infura.provider")
// let network = "ropsten" //   rinkeby 
// const {projectId,privateKeys, adminKey} = require('/Users/liyu/Desktop/key/secrets.json');
// let Web3 = require("web3")

// let host = `https://${network}.infura.io/v3/${projectId}`
 

// const {setupLoader} = require('@openzeppelin/contract-loader');
// const loader = setupLoader({
//     provider: host,
//     defaultGas: 8e6,
//     defaultGasPrice: 20e9
// }).truffle;

// const AaveAPR = loader.fromArtifact("AaveAPR")
 
describe('AaveAPR start starking', async () => { 
    beforeEach(async () => {

           
        const {AaveAPR, accounts, web3, BN, constants} = await provider.getArttifact();
        // console.log(AaveAPR)
        let [owner, sender] = accounts;
        
        // console.log("owner", owner)
        // console.log("sender", sender)

        this.AaveAPR = await AaveAPR.new(sender) 
        console.log("AaveAPR",this.AaveAPR.address)
    });
    it ("Deploy",()=>{

    })
})