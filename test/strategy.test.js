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
 

//ropsten 
// aave arp =  0x71D7D6E70435229014e02CFE63a7a8E34BbF2d0c
// dai = 0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108

// comp arp =  0x3B0B789D92D7Ff6B74580F566a48b98DD043Cf2D
// dai = 0x0d9c8723b343a8368bebe0b5e89273ff8d712e3c

// lenderAPR = 0x3544e9b8B0f9Ce4dD01B2C89700BdC9FE22e09aa

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