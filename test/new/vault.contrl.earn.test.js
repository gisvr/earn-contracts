let nodeProvider = require("../../utils/ganache.provider")

let ethAddr = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
const {
    BN
} = require("@openzeppelin/test-helpers");

const { expect } = require("chai");

let web3, amount = (new BN(10)).pow(new BN(18));

let sender, alice, bob;
describe('mVault ETH DAI ganache', async () => {

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
        let _mController = await nodeProvider.getEarn("mController");
        this.mController = await _mController.new();

        let _mVault = await nodeProvider.getEarn("mVault");
        this.mVault = await _mVault.new();


        // EarnController
        let _earnController = await nodeProvider.getEarn("EarnController");
        this.EarnController = await _earnController.new(this.mVault.address,this.mController.address);

        await this.mVault.setEarnController(this.EarnController.address);
        await this.mController.setEarnController(this.EarnController.address);

        // StrategyLender
        let _strategyLender = await nodeProvider.getEarn("StrategyLender");

        // Set ETH Strategy
        this.StrategyLenderETH = await _strategyLender.new(
            ethAddr,
            this.EarnController.address,
            this.LenderAPR.address); 

        // Set DAI Strategy
        this.StrategyLenderDAI = await _strategyLender.new(
            this.DAI.address,
            this.EarnController.address,
            this.LenderAPR.address);

        await this.EarnController.setStrategy(this.DAI.address, this.StrategyLenderDAI.address);
 

        await  this.EarnController.setStrategy(ethAddr,this.StrategyLenderETH.address); 
 
    })

    it("mVault earn ETH", async () => { 
        let mAddr = this.mVault.address
  
        let balance1 =await web3.eth.getBalance(sender) 
        
        await web3.eth.sendTransaction({
            from:sender,
            to:mAddr, 
            value:amount, 
        });
        let mBal1 = await await web3.eth.getBalance(mAddr)
        expect(mBal1).to.be.bignumber.eq(amount,"ETH 合约充值余额");

        let tx=  await this.mController.earn(ethAddr)
        // await this.mVault.vaultTransfer(ethAddr,sender);
        
        let mBal2 =  await web3.eth.getBalance(mAddr)

        

        expect(mBal2).to.be.bignumber.eq(new BN(0),"ETH 合约earn余额")
 
    }).timeout(50000)

    it("mVault withdraw ETH", async () => {  
        let mAddr = this.mVault.address 
        let bal =  await this.mVault.balanceAll(ethAddr)
 
        await this.mController.withdraw(ethAddr,bal) 
        let mBal3 = await web3.eth.getBalance(mAddr)
        await this.mVault.inCaseETHGetsStuck()  
        // expect(mBal3).to.be.bignumber.eq(bal,"ETH 合约withdraw余额");
 
    }).timeout(50000)


    it("mVault earn DAI", async () => {
        let reserve = this.DAI;
        let reserveAddr = reserve.address;
        let mAddr = this.mVault.address
 
        await reserve.approve(mAddr, amount.add(amount))
        let balance1 = await reserve.balanceOf(sender); 
        await reserve.transfer(mAddr, amount);
        let mBal1 = await reserve.balanceOf(mAddr)
        expect(mBal1).to.be.bignumber.eq(amount,"DAI 合约充值余额");

        await this.mController.earn(reserveAddr)
 

        let mBal2 = await reserve.balanceOf(mAddr)
        expect(mBal2).to.be.bignumber.eq(new BN(0),"DAI 合约earn余额")
 
    }).timeout(50000)

    it("mVault withdraw DAI", async () => { 
        let reserve = this.DAI;
        let reserveAddr = reserve.address;
        let mAddr = this.mVault.address 
        let bal =  await this.mVault.balanceAll(reserveAddr)
        await this.mController.withdraw(reserveAddr,bal) 
        let mBal3 = await reserve.balanceOf(mAddr) 
        await this.mVault.inCaseTokenGetsStuck(reserveAddr)  
        // expect(mBal3).to.be.bignumber.eq(bal,"DAI 合约withdraw余额"); 
 
    }).timeout(50000)


})
