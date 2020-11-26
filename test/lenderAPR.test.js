const {accounts, contract, web3} = require("@openzeppelin/test-environment");
const {
    BN,          // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const {expect} = require("chai");

// Mocker
const LendingPoolAddressesProvider = contract.fromArtifact("LendingPoolAddressesProvider"); // Loads a compiled contract
const LendingPoolCore = contract.fromArtifact("LendingPoolCore");
const ReserveInterestRateStrategy = contract.fromArtifact("ReserveInterestRateStrategy");

// APR
const AaveAPR = contract.fromArtifact("AaveAPR");

// APR
const LenderAPR = contract.fromArtifact("LenderAPR");
 

describe("Lender  APR", function () {
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

        this.lenderAPR = await LenderAPR.new()  
        await this.lenderAPR.addLender("AAVE",this.AaveAPR.address); 

    });

    it("recommend ARP ", async () => {  
        let name = await this.AaveAPR.name() 
         console.log("name",name)
 
        let recommend = await this.lenderAPR.recommend(bob)
        console.log(recommend) 
        let recommendAll = await this.lenderAPR.recommendAll(bob)
        console.log(recommendAll)

    });
  
});