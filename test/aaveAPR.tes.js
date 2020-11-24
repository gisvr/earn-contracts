const {accounts, contract, web3} = require("@openzeppelin/test-environment");
const {
    BN,          // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const {expect} = require("chai");

const LendingPoolAddressesProvider = contract.fromArtifact("LendingPoolAddressesProvider"); // Loads a compiled contract
const LendingPoolCore = contract.fromArtifact("LendingPoolCore");
const ReserveInterestRateStrategy = contract.fromArtifact("ReserveInterestRateStrategy");
const AaveAPR = contract.fromArtifact("AaveAPR");
 

describe("Strategy AaveAPR", function () {
    const [alice, bob, carol, minter] = accounts;
    beforeEach(async () => {
        // this.value = new BN(60000000);

        let lpProvider = await LendingPoolAddressesProvider.new();

        let lpCore = await LendingPoolCore.new();
        
        await lpProvider.setLendingPoolCore(lpCore.address)

        let lpStrategy = await ReserveInterestRateStrategy.new();
        await lpCore.setReserveInterestRateStrategyAddress(lpStrategy.address)

        this.AaveAPR = await AaveAPR.new(lpProvider.address); 

       
        expect(await this.AaveAPR.getAaveCore()).to.equal(lpCore.address);
 
    });

    it("ARP and Arp Adjusted", async () => { 
       let arp = await this.AaveAPR.getAPR(alice)
       console.log("ARP",arp.toString())
       let arpAdjusted = await this.AaveAPR.getAPRAdjusted(alice,1) 
       console.log("arpAdjusted",arpAdjusted.toString())
    });
 


});


