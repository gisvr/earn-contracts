const {accounts, contract, web3} = require("@openzeppelin/test-environment");
const {
    BN,          // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const {expect} = require("chai");

const CToken = contract.fromArtifact("CToken"); // Loads a compiled contract
const InterestRateModel = contract.fromArtifact("InterestRateModel"); 

const CompoundAPR = contract.fromArtifact("CompoundAPR");
 

describe("Strategy Compound APR", function () {
    const [alice, bob, carol, minter] = accounts;
    beforeEach(async () => {
        // this.value = new BN(60000000);

        //memory name, string memory symbol, uint256 initialSupply, uint8 decimals
        this.cToken = await CToken.new("name","MC","100","18");

        let rateModel = await InterestRateModel.new();
        
        await this.cToken.setInterestRateModel(rateModel.address)
 
        this.APR = await CompoundAPR.new(); 
 
        expect(await this.cToken.interestRateModel()).to.equal(rateModel.address);
 
    });

    it("ARP and Arp Adjusted", async () => { 
       let tokenAddress = this.cToken.address
       let arp = await this.APR.getAPR(tokenAddress)
       console.log("ARP",arp.toString())
       let arpAdjusted = await this.APR.getAPRAdjusted(tokenAddress,1) 
       console.log("arpAdjusted",arpAdjusted.toString())
    });
 
});


