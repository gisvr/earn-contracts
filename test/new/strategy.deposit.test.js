let nodeProvider = require("../../utils/ganache.provider")

let ethAddr = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
const {
    BN
} = require("@openzeppelin/test-helpers");

const { expect } = require("chai");

let web3, amount = (new BN(10)).pow(new BN(18));

let sender, alice, bob;
describe('mVault ganache', async () => {

    beforeEach(async () => {
        this.DAI = await nodeProvider.getAave("MockDAI");
        this.BAT = await nodeProvider.getAave("MockBAT");
        this.USDT = await nodeProvider.getAave("MockUSDT");
        let _aaveProvider = await nodeProvider.getAave("LendingPoolAddressesProvider");

        [sender, alice, bob] = nodeProvider.getAccounts()
        web3 = nodeProvider.getWeb3()
        // BN = web3.utils.BN 

        //创建一个依赖测试节点的 arp
        let _aaveAPR = await nodeProvider.getEarn("AaveAPR");
        let aaveProvider = _aaveProvider.address;
        this.AaveAPR = await _aaveAPR.new(aaveProvider);

        // Lender APR
        let _lenderAPR = await nodeProvider.getEarn("LenderAPR");
        this.LenderAPR = await _lenderAPR.new();
        await this.LenderAPR.addLender(this.AaveAPR.address)

        // mVault
        let _mVault = await nodeProvider.getEarn("mVault");
        this.mVault = await _mVault.new();


        // EarnController
        let _earnController = await nodeProvider.getEarn("EarnController");
        this.EarnController = await _earnController.new(this.mVault.address);

        await this.mVault.setController(this.EarnController.address);

        // StrategyLender
        let _strategyLender = await nodeProvider.getEarn("StrategyLender");

        // Set ETH Strategy
        // this.StrategyLenderETH = await _strategyLender.new(ethAddr,this.EarnController.address); 
        // await  this.EarnController.setStrategy(ethAddr,this.StrategyLenderETH.address);

        // Set DAI Strategy
        this.StrategyLenderDAI = await _strategyLender.new(
            this.DAI.address,
            this.EarnController.address,
            this.LenderAPR.address);
        await this.EarnController.setStrategy(this.DAI.address, this.StrategyLenderDAI.address);


    })

    it.skip("StrategyLenderDAI _rebalance DAI", async () => {
        let reserve = this.DAI;
        let reserveAddr = reserve.address;
        let tx = await this.StrategyLenderDAI._rebalance()
        console.log(tx.tx)
    })


    it("StrategyLenderDAI deposit DAI", async () => {
        let reserve = this.DAI;
        let reserveAddr = reserve.address;
        let mAddr = this.StrategyLenderDAI.address

        await reserve.approve(mAddr, amount)
        let balance1 = await reserve.balanceOf(sender);
        console.log("sender balance", balance1.toString())
        await reserve.transfer(mAddr, amount);
        let mBal1 = await reserve.balanceOf(mAddr)
        expect(mBal1).to.be.bignumber.eq(amount,"合约充值余额");

        await this.StrategyLenderDAI.deposit()
        let mBal2 = await reserve.balanceOf(mAddr)
        expect(mBal2).to.be.bignumber.eq(new BN(0),"合约Deposit余额")

        await this.mVault.withdraw(reserveAddr, amount.div(new BN(2)))
        let mBal3 = await reserve.balanceOf(mAddr)
        expect(mBal3).to.be.bignumber.eq(amount,"合约withdraw余额");



    }).timeout(50000)

    it.skip("mVault withdraw DAI", async () => {


    }).timeout(50000)


})
