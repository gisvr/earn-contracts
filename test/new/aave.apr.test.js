let nodeProvider = require("../../utils/ganache.provider")
// let compZRX = "0x00e02a5200ce3d5b5743f5369deb897946c88121" // comp ctoken
let zrx = "0xFD13958386b6AC7d3FEdb310A766ca2008d840Bf" // underlying aaveDai
// let aaveDai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108" //underlying

describe('AaveAPR ganache', async () => {
    let ower, user1;
    beforeEach( async()=>{ 
        [ower, user1] = nodeProvider.getAccounts() 
        let _aaveProvider = await nodeProvider.getAave("LendingPoolAddressesProvider");
        let _aaveAPR = await nodeProvider.getEarn("AaveAPR");
        let _lenderAPR = await nodeProvider.getEarn("LenderAPR");
        let aaveProvider =_aaveProvider.address; 
        //创建一个依赖测试节点的 arp
        this.AaveAPR = await _aaveAPR.new(aaveProvider);

        // 
        this.LenderAPR = await _lenderAPR.new();
        await this.LenderAPR.addLender(this.AaveAPR.address)

        this.DAI = await nodeProvider.getAave("MockDAI"); 
        this.BAT = await nodeProvider.getAave("MockBAT"); 
        this.USDT = await nodeProvider.getAave("MockUSDT"); 
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
