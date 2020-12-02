let provider = require("../utils/provider")
let compZRX = "0x00e02a5200ce3d5b5743f5369deb897946c88121" // comp ctoken
let zrx = "0xe4c6182ea459e63b8f1be7c428381994ccc2d49c" // underlying
let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108" //underlying

describe('AaveAPR ropsten', async () => {
    it("Compound balanceOf", async () => {
        let ERC20 =await provider.getArttifact("ERC20")
        let accounts = provider.getAccounts()
        let erc20 = await ERC20.at(zrx)
        let name = await erc20.name()
        console.log(name)
        for (let account of accounts) {
            let apr = await erc20.balanceOf(account.address)
            console.log(apr.toString());
        }

        let strategyLender =await provider.getArttifact("StrategyLender")

        let strategyBal = await erc20.balanceOf(strategyLender.address)
        console.log("strategyBal",strategyBal.toString());

    }).timeout(50000)

    it("Compound recmmend", async () => {
        let lenderAPR =await provider.getArttifact("LenderAPR")
        let recommend = await lenderAPR.recommend(zrx)
        console.log(recommend)
    }).timeout(50000)

    it("StrategyLender deposit", async () => {
        let ERC20 =await provider.getArttifact("ERC20")
        let [ower, user1] = provider.getAccounts()
        let erc20 = await ERC20.at(zrx)
        let apr = await erc20.balanceOf(user1.address)
        // console.log(apr.toString());
        let strategyLender =await provider.getArttifact("StrategyLender")
        let foo1 = await erc20.transfer(strategyLender.address, 10e18.toString(), {from: user1.address})
        // console.log(foo1)
        let foo2 = await erc20.balanceOf(strategyLender.address)
        console.log("strategyLender balanceOf",foo2.toString())
        let recommend = await strategyLender.deposit()
        console.log(recommend)
        // https://ropsten.etherscan.io/tx/0xe29bbce979f63075c764a5f62b4f60f481aee2509020a9aa7e394e1404bae244#eventlog
    }).timeout(500000)

    it("StrategyLender balance", async () => {
        let strategyLender =await provider.getArttifact("StrategyLender")
        let recommend = await strategyLender.balanceRecommend()
        // let recommend = await strategyLender._balance()
        console.log("balanceRecommend",recommend.toString())
    }).timeout(500000)

    it("StrategyLender comp balance", async () => {
        let strategyLender =await provider.getArttifact("StrategyLender")
        let recommend = await strategyLender.compBalance()
        // let recommend = await strategyLender._balance()
        console.log(recommend.toString())
    }).timeout(500000)

    it("StrategyLender redeem", async () => {
        let strategyLender =await provider.getArttifact("StrategyLender")
        let [ower, user1] = provider.getAccounts()
        let balance = await strategyLender.balanceRecommend()
        let recommend = await strategyLender.redeemCompound(compZRX,balance)
        console.log(recommend)
    }).timeout(500000)

    it("StrategyLender inCaseTokenGetsStuck", async () => {
        let strategyLender =await provider.getArttifact("StrategyLender")
        let [ower, user1,user2] = provider.getAccounts()
        let balance = await strategyLender.balanceRecommend()
        console.log(balance.toString());
        let recommend = await strategyLender.inCaseTokenGetsStuck(zrx,{from: user2.address})
        console.log(recommend)
    }).timeout(500000)




})
