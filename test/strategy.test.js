const {accounts, contract, web3} = require("@openzeppelin/test-environment");
const {
    BN,          // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const {expect} = require("chai");

// Mocker 
const MockERC20 = contract.fromArtifact("MockERC20");
const mController = contract.fromArtifact("mController");



// Lender APR
const AaveAPR = contract.fromArtifact("MockAPR");

// Recmmand APR
const LenderAPR = contract.fromArtifact("LenderAPR");

// 
const StrategyLender = contract.fromArtifact("StrategyLender");
 

describe("Strategy  Lender", function () {
    const [alice, bob, carol, minter] = accounts;
    beforeEach(async () => {
        this.value = new BN(60000000);
         
        this.mockWant = await MockERC20.new("MC name", "MC", this.value, 18, {from: minter});  
        this.AaveAPR = await AaveAPR.new("AAVE",this.mockWant.address);   
        // --------apr-----
        this.lenderAPR = await LenderAPR.new()  
        await this.lenderAPR.addLender("AAVE",this.AaveAPR.address); 

        //----------straetgy-----
      
        this.mController = await mController.new(bob);

        this.StrategyLender = await StrategyLender.new(this.mController.address,this.mockWant.address,this.lenderAPR.address);
    });

    it("StrategyLender  deposit ", async () => {  
        
        await this.mockWant.transfer(this.StrategyLender.address, '10000', {from: minter});

        let recommendAll = await this.StrategyLender.deposit()
        console.log(recommendAll)

    });
  
});