let provider = require("../utils/ganache.provider")
// let compZRX = "0x00e02a5200ce3d5b5743f5369deb897946c88121" // comp ctoken
let zrx = "0xFD13958386b6AC7d3FEdb310A766ca2008d840Bf" // underlying aaveDai
// let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108" //underlying

describe('AaveAPR ganache', async () => {
    let ower, user1;
    beforeEach( async()=>{
        this.ERC20 =await provider.getArttifact("ERC20");
        this.mVault =await provider.getArttifact("mVault");
       [ower, user1] = provider.getAccounts()

    })


    it("mVault deposit", async () => {
        let mVault = this.mVault;
        let erc20 = await this.ERC20.at(zrx)
        await erc20.approve(mVault.address, 18e18.toString(), {from: user1});
        let recommend = await mVault.deposit(zrx,2e18.toString(), {from: user1});
        console.log(recommend)
        //https://ropsten.etherscan.io/tx/0x941fc8710f716596a20b68a4c486ae474c49e5846e213101ffc5f64a18196931
    }).timeout(500000)


    it("mVault balance", async () => {
        let mVault = this.mVault;

        let foo2 =await mVault.balance(zrx)
        console.log("mVaultBal ",foo2.toString());

        let foo1 =await mVault.balanceAll(zrx)
        console.log("mVaultBal all",foo1.toString());


    }).timeout(500000)

    it("mVault earn", async () => {
        let mVault = this.mVault;
        let earn = await mVault.earn(zrx,{from: user1})
        console.log(earn)
    }).timeout(500000)

    it("mVault withdraw", async () => {
        let mVault = this.mVault;

        let foo1 =await mVault.balanceAll(zrx)
        console.log("mVaultBal all",foo1.toString());



        await mVault.inCaseTokenGetsStuck(zrx,{from: user1})

        let withdraw = await mVault.withdraw(zrx,1e18.toString(),{from: user1})
        console.log(withdraw.tx)


        let foo2 =await mVault.balance(zrx)
        console.log("mVaultBal end",foo2.toString());
        // https://ropsten.etherscan.io/tx/0xca0a7e1e5361eae250d1baadc0645718658a0018edd2bd6956ca189552394f1c
    }).timeout(500000)



})
