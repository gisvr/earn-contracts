let provider = require("../utils/provider")
let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108" //underlying
let aaveETH = "0x2433A1b6FcF156956599280C3Eb1863247CFE675" //atoken

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

    it("aave depoist ETH", async () => {
        let _token = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
        let IAave = await provider.getArttifact("IAave")
        let accounts = provider.getAccounts()
        let [ower, user1,user2] = provider.getAccounts()
        let aave = await IAave.at("0x9E5C7835E4b13368fd628196C4f1c6cEc89673Fa")

        let tx = await aave.deposit(_token,"15",0,{from: user2,value:20});
        console.log("tx", tx);

    }).timeout(50000)

    it("StrategyLender aave deposit ETH", async () => { 
        let strategyLender =await provider.getArttifact("StrategyLenderETH") 
        let tx = await strategyLender.deposit({from: user2,value:20})
        console.log(tx)
        
    }).timeout(500000)

    it("aave depoist ERC20", async () => {
        let _token = aaveDai;
        let IAave = await provider.getArttifact("IAave")
        let accounts = provider.getAccounts()
        let [ower, user1,user2] = provider.getAccounts()
        let aave = await IAave.at("0x9E5C7835E4b13368fd628196C4f1c6cEc89673Fa")

        let ERC20 = await provider.getArttifact("ERC20")
        let erc20 = await ERC20.at(_token);

        let core = "0x4295Ee704716950A4dE7438086d6f0FBC0BA9472";
        await erc20.approve(core, 18e18.toString(), {from: user2});

        let tx = await aave.deposit(_token,"60",0,{from: user2});
        console.log("tx", tx);

    }).timeout(50000)

    it("aave transfer", async () => {
        let AToken = await provider.getArttifact("IAToken")
        let ERC20 = await provider.getArttifact("ERC20")
        let accounts = provider.getAccounts()
        let [ower, user1,user2] = provider.getAccounts()
        let aToken = await AToken.at(aaveETH)
        let erc20 = await ERC20.at(aaveETH);
        let contractAdrr = "0x18c257e4106661c99BFFCcf3eDD605935035Cdb6"
        // await erc20.approve(contractAdrr, 18e18.toString(), {from: user2});

        let tx = await aToken.transfer(contractAdrr,"2000",{from: user2})
        console.log("tx", tx);

    }).timeout(50000)

})
