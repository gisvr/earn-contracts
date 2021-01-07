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
        let aaveProvider =_aaveProvider.address; 
        this.AaveAPR = await _aaveAPR.new(aaveProvider);
        this.DAI = await nodeProvider.getAave("MockDAI"); 
        this.BAT = await nodeProvider.getAave("MockBAT"); 
        this.USDT = await nodeProvider.getAave("MockUSDT"); 
    }) 
    it("AaveAPR getAPR", async () => {  
        let tokenApr = await this.AaveAPR.getAPR(this.USDT.address);  
        console.log(tokenApr.toString())

    }).timeout(50000)
 
})
