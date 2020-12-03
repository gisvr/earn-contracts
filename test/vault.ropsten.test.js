let provider = require("../utils/provider")
let compZRX = "0x00e02a5200ce3d5b5743f5369deb897946c88121" // comp ctoken
let zrx = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c" // underlying
let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108" //underlying

describe('AaveAPR ropsten', async () => {
    let ower, user1;
    beforeEach( async()=>{
        this.ERC20 =await provider.getArttifact("ERC20");
        this.mVault =await provider.getArttifact("mVault");
       [ower, user1] = provider.getAccounts()

    })

    it("mVault balanceOf", async () => {
        let erc20 = await this.ERC20.at(this.mVault.address)

        let mVaultBal = await erc20.balanceOf(user1.address)
        console.log("mVault",mVaultBal.toString());
    }).timeout(500000)




    it("mVault deposit", async () => {
        let mVault = this.mVault;
        let erc20 = await this.ERC20.at(zrx)
        await erc20.approve(mVault.address, 18e18.toString(), {from: user1});
        let recommend = await mVault.deposit(2e18.toString(), {from: user1});
        console.log(recommend)
        //https://ropsten.etherscan.io/tx/0x941fc8710f716596a20b68a4c486ae474c49e5846e213101ffc5f64a18196931
    }).timeout(500000)


    it("mVault balance", async () => {
        let mVault = this.mVault;

        let foo2 =await mVault.balance()
        console.log("mVaultBal all",foo2.toString());

        let erc20 = await this.ERC20.at(mVault.address)

        let mVaultBal = await erc20.balanceOf(user1.address)

        console.log("mVaultBal user ",mVaultBal.toString());

    }).timeout(500000)

    it("mVault earn", async () => {
        let mVault = this.mVault;
        let earn = await mVault.earn({from: user1})
        console.log(earn)
        // https://ropsten.etherscan.io/tx/0x7b40a7583ee8846ffdeca7bfadb72d5b2b4ba8e224d59475a08b6fa6b4d57da0
    }).timeout(500000)

    it("mVault withdraw", async () => {
        let mVault = this.mVault;
        let withdraw = await mVault.withdraw(1e10.toString(),{from: user1})
        console.log(withdraw)
        // https://ropsten.etherscan.io/tx/0xca0a7e1e5361eae250d1baadc0645718658a0018edd2bd6956ca189552394f1c
    }).timeout(500000)



})
