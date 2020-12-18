

const {contract} = require("@openzeppelin/test-environment");
let network = "ropsten" //   rinkeby
const {projectId,privateKeys, adminKey} = require('/Users/liyu/Desktop/key/secrets.json');
let host = `https://${network}.infura.io/v3/${projectId}`
let Web3 = require("web3")
const web3 = new Web3(host)

const AaveAPR = contract.fromArtifact("AaveAPR")
const CompoundAPR = contract.fromArtifact("CompoundAPR")
const LenderAPR = contract.fromArtifact("LenderAPR");

describe('AaveAPR ropsten', async () => {

    before(async () => {
        let accounts = []
        privateKeys.map(val => {
            let account = web3.eth.accounts.wallet.add(val)
            accounts.push(account.address)
        })
        let wallet = web3.eth.accounts.wallet
        let [owner,user1,user2] = accounts

        AaveAPR.setProvider(web3.currentProvider)
        AaveAPR.defaults({
            from:owner,
            defaultGas: 8e6,
            defaultGasPrice: 20e9
        });

        CompoundAPR.setProvider(web3.currentProvider)
        CompoundAPR.defaults({
            from:owner,
            defaultGas: 8e6,
            defaultGasPrice: 20e9
        });



        LenderAPR.setProvider(web3.currentProvider)
        LenderAPR.setWallet(wallet)
        LenderAPR.defaults({
            from:user2,
            defaultGas: 8e6,
            defaultGasPrice: 20e9
        });

        this.CompoundAPR = await CompoundAPR.at("0x3B0B789D92D7Ff6B74580F566a48b98DD043Cf2D")
        this.AaveAPR = await AaveAPR.at("0x6A3dc85d73E0e9A7D6C3025a31Cf5cDf68CC9bF5")
        this.LenderAPR = await LenderAPR.at("0x3544e9b8B0f9Ce4dD01B2C89700BdC9FE22e09aa")

    })

    it ("AaveAPR getLpToken",async ()=>{
        let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108"
        // let apr  =  await this.AaveAPR.name()
        // let apr =  await this.AaveAPR.getAaveCore()
         let apr =   await this.AaveAPR.getLpToken(aaveDai)
        // let apr = await this.AaveAPR.getAPR(aaveDai)
         console.log(apr);
    }).timeout(5000)

    it ("CompoundAPR getLpToken",async ()=>{
        let dai = "0x0d9c8723b343a8368bebe0b5e89273ff8d712e3c"
        let lpDai = "0x8aF93cae804cC220D1A608d4FA54D1b6ca5EB361"
        // let apr  =  await this.CompoundAPR.name()
        // let apr =   await this.CompoundAPR.getLpToken(dai)

        let apr = await this.CompoundAPR.getAPR(lpDai)
        console.log(apr.toString());
    }).timeout(5000)

    it ("LenderAPR addLender comp",async ()=>{
        // let apr =   await this.LenderAPR.addLender("Compound","0x3B0B789D92D7Ff6B74580F566a48b98DD043Cf2D")
        // console.log(apr);
    }).timeout(100000)

    it ("LenderAPR removeLender comp",async ()=>{
        let apr =   await this.LenderAPR.removeLender(0)
        console.log(apr);
    }).timeout(100000)

    it ("LenderAPR aave recommend",async ()=>{
        let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108"
        let apr =   await this.LenderAPR.recommend(aaveDai)
        console.log(apr);
    }).timeout(6000)

    it ("LenderAPR comp recommend",async ()=>{
        let compDaiLP = "0x8aF93cae804cC220D1A608d4FA54D1b6ca5EB361"
        let apr =   await this.LenderAPR.recommend(compDaiLP)
        console.log(apr);
    }).timeout(6000)
})
