let nodeProvider = require("../../utils/ganache.provider")

let ethAddr = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
const {
    BN
} = require("@openzeppelin/test-helpers");

const { expect } = require("chai");

let web3, amount = (new BN(10)).pow(new BN(18));

let sender, alice, bob;
describe('mVault ganache', async () => {

    before(async () => {
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
 

        // Set DAI Strategy
        this.StrategyLenderDAI = await _strategyLender.new(
            this.DAI.address,
            this.EarnController.address,
            this.LenderAPR.address);

        await this.EarnController.setStrategy(this.DAI.address, this.StrategyLenderDAI.address);
 
    })

    it("mVault earn DAI", async () => {
        let reserve = this.DAI;
        let reserveAddr = reserve.address;
        let mAddr = this.mVault.address
 
        await reserve.approve(mAddr, amount.add(amount))
        let balance1 = await reserve.balanceOf(sender);
        console.log("sender balance",balance1.toString())
        await reserve.transfer(mAddr, amount);
        let mBal1 = await reserve.balanceOf(mAddr)
        expect(mBal1).to.be.bignumber.eq(amount,"DAI 合约充值余额");

        await this.mVault.earn(reserveAddr)
        let mBal2 = await reserve.balanceOf(mAddr)
        expect(mBal2).to.be.bignumber.eq(new BN(0),"DAI 合约earn余额")
 
    }).timeout(50000)

    it("mVault withdraw DAI", async () => { 
        let reserve = this.DAI;
        let reserveAddr = reserve.address;
        let mAddr = this.mVault.address 
        let bal =  await this.mVault.balanceAll(reserveAddr)
        await this.mVault.withdraw(reserveAddr,bal) 
        let mBal3 = await reserve.balanceOf(mAddr) 
        await this.mVault.inCaseTokenGetsStuck(reserveAddr)  
        expect(mBal3).to.be.bignumber.eq(bal,"DAI 合约withdraw余额");
 
    }).timeout(50000)


})
