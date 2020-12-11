let provider = require("../utils/ganache.provider")
let aaveDai = "0x7C728214be9A0049e6a86f2137ec61030D0AA964" //underlying

describe('AaveAPR ropsten', async () => {
    let owner, user1;
    beforeEach( async()=>{
        this.ERC20 =await provider.getArttifact("ERC20");
        this.mController =await provider.getArttifact("mController");
        this.StrategyLender =await provider.getArttifact("StrategyLender");
       [owner, user1] = provider.getAccounts()

    })

    it("mController deposit erc20", async () => {
        let mController = this.mController;
        let erc20 = await this.ERC20.at(aaveDai)
        await erc20.approve(mController.address, 18e18.toString(), {from: user1});
        let recommend = await mController.deposit(2e18.toString(), {from: user1});
        console.log(recommend)
        //https://ropsten.etherscan.io/tx/0x941fc8710f716596a20b68a4c486ae474c49e5846e213101ffc5f64a18196931
    }).timeout(500000)


    it("mController erc20 balanceOf", async () => {
        let erc20 = await this.ERC20.at(aaveDai)

        let mVaultBal = await erc20.balanceOf(this.mController.address);
        console.log("mControllerBall",mVaultBal.toString());

        let strategyBal = await erc20.balanceOf(this.StrategyLender.address);
        console.log("strategyBal",strategyBal.toString());

        let user1tBal = await erc20.balanceOf(owner);
        console.log("user1tBal",user1tBal.toString());

    }).timeout(500000)

    it("mController balanceOf", async () => {
        let mController = this.mController;

        let foo2 =await mController.balanceOf(aaveDai);
        console.log("mController all",foo2.toString());
    }).timeout(500000)




    it("mController earn", async () => {
        let mController = this.mController;
        let foo1 =await mController.balanceOf(aaveDai);
        console.log("mController all",foo1.toString());
        let earn = await mController.earn(aaveDai,1,{from: owner})

        let foo2 =await mController.balanceOf(aaveDai);
        console.log(foo2.toString())
        // https://ropsten.etherscan.io/tx/0x7b40a7583ee8846ffdeca7bfadb72d5b2b4ba8e224d59475a08b6fa6b4d57da0
    }).timeout(500000)

    it("mController withdraw", async () => {
        let erc20 = await this.ERC20.at(aaveDai)
        let mController = this.mController;
        let user1tBal = await erc20.balanceOf(user1);

        let mVaultBal = await erc20.balanceOf(this.mController.address);
        console.log("mControllerBall",mVaultBal.toString());

        let strategyBal = await erc20.balanceOf(this.StrategyLender.address);
        console.log("strategyBal",strategyBal.toString());

        console.log("user1tBal",user1tBal.toString());
        let withdraw = await mController.withdraw(aaveDai,100,{from: user1})

        console.log("--------- mController withdraw -----------------")
        let mVaultBal1 = await erc20.balanceOf(this.mController.address);
        console.log("mControllerBall",mVaultBal1.toString());

        let strategyBal1 = await erc20.balanceOf(this.StrategyLender.address);
        console.log("strategyBal",strategyBal1.toString());

        let user1tBal1 = await erc20.balanceOf(user1);
        console.log("user1tBal1",user1tBal1.toString());

        // https://ropsten.etherscan.io/tx/0xca0a7e1e5361eae250d1baadc0645718658a0018edd2bd6956ca189552394f1c
    }).timeout(500000)



})
