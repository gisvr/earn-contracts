let provider = require("../utils/provider")
let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108" //underlying
let aaveETH = "0x2433A1b6FcF156956599280C3Eb1863247CFE675" //underlying

describe('AaveAPR ropsten', async () => {
    it("aave balanceOf", async () => {
        let ERC20 = await provider.getArttifact("IAToken")
        let accounts = provider.getAccounts()
        let erc20 = await ERC20.at(aaveETH)

        for (let account of accounts) {
            let apr = await erc20.balanceOf(account.address)
            console.log(apr.toString());
        }

        // let strategyLender =await provider.getArttifact("StrategyLender")

        // let strategyBal = await erc20.balanceOf(strategyLender.address)
        // console.log("strategyBal",strategyBal.toString());

    }).timeout(50000)

    it("aave redeem", async () => {
        let ERC20 = await provider.getArttifact("IAToken")
        let accounts = provider.getAccounts()
        let [ower, user1,user2] = provider.getAccounts()
        let erc20 = await ERC20.at(aaveETH)


        let redeem = await erc20.redeem("10",{from: user2.address})
        console.log("redeem", redeem);

    }).timeout(50000)

    it("aave transfer", async () => {
        let AToken = await provider.getArttifact("IAToken")
        let ERC20 = await provider.getArttifact("ERC20")
        let accounts = provider.getAccounts()
        let [ower, user1,user2] = provider.getAccounts()
        let aToken = await AToken.at(aaveETH)
        let erc20 = await ERC20.at(aaveETH);
        let contractAdrr = "0x18c257e4106661c99BFFCcf3eDD605935035Cdb6"
        await erc20.approve(contractAdrr, 18e18.toString(), {from: user2});

        // let redeem = await aToken.transfer(contractAdrr,"2000",{from: user2})
        // console.log("redeem", redeem);

    }).timeout(50000)

})
