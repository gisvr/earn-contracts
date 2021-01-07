let nodeProvider = require("../../utils/ganache.provider") 
describe('AaveAPR ganache', async () => {
    let ower, user1;
    beforeEach( async()=>{  
        this.DAI = await nodeProvider.getAave("MockDAI"); 
        this.BAT = await nodeProvider.getAave("MockBAT"); 
        this.USDT = await nodeProvider.getAave("MockUSDT"); 
        let _aaveProvider = await nodeProvider.getAave("LendingPoolAddressesProvider");

        [ower, user1] = nodeProvider.getAccounts() 

         //创建一个依赖测试节点的 arp
        let _aaveAPR = await nodeProvider.getEarn("AaveAPR"); 
        let aaveProvider =_aaveProvider.address;  
        this.AaveAPR = await _aaveAPR.new(aaveProvider);

        // Lender APR
        let _lenderAPR = await nodeProvider.getEarn("LenderAPR");
        this.LenderAPR = await _lenderAPR.new();
        await this.LenderAPR.addLender(this.AaveAPR.address)
 
    }) 

    it("LenderAPR recommend ETH", async () => {  
        let _ethAddr = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
        let tokenApr = await this.LenderAPR.recommend(_ethAddr); 
        console.log("ETH recommend",tokenApr.toString())
        let tokenALL = await this.LenderAPR.recommendAll(_ethAddr); 
        console.log("ETH recommendAll",tokenALL )

    }).timeout(50000)

    it("AaveAPR getAPR ETH", async () => {  
        let _ethAddr = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
        let tokenApr = await this.AaveAPR.getAPR(_ethAddr); 
        console.log("ETH APR",tokenApr.toString())

    }).timeout(50000)
    it("AaveAPR getAPR USDT", async () => {  
        let tokenApr = await this.AaveAPR.getAPR(this.USDT.address);  
        console.log("USDT APR",tokenApr.toString())

    }).timeout(50000)
 
})
