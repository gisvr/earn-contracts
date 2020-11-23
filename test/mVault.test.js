const {accounts, contract, web3} = require("@openzeppelin/test-environment");
const {
    BN,          // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const {expect} = require("chai");

const mVault = contract.fromArtifact("mVault"); // Loads a compiled contract
const MockERC20 = contract.fromArtifact("MockERC20");
const mController = contract.fromArtifact("mController");
const Strategy = contract.fromArtifact("Strategy");

const OneSplitAudit = contract.fromArtifact("OneSplitAudit");

describe("mVault", function () {
    const [alice, bob, carol, minter] = accounts;
    beforeEach(async () => {
        this.value = new BN(60000000);

        this.mockOneSplitAudit = await OneSplitAudit.new("Mock OneSplit");

        this.mockERC20 = await MockERC20.new("MC name", "MC", this.value, 18, {from: minter});

        this.mockERC2 = await MockERC20.new("MC 2 name", "MC", this.value, 18, {from: minter});

        this.mController = await mController.new(bob);
        this.Strategy = await Strategy.new(this.mController.address,this.mockERC20.address);
        this.Strategy2 = await Strategy.new(this.mController.address,this.mockERC20.address);

        let want =

        // console.log(this.mController.address)

        this.mVault = await mVault.new(this.mockERC20.address, this.mController.address);
    });

    it("should have correct name and symbol and decimal", async () => {
        expect(await this.mockOneSplitAudit.name()).to.equal("Mock OneSplit");
        expect(await this.mVault.name()).to.equal("mEarn MC name");
        expect(await this.mVault.symbol()).to.equal("mMC");
        expect(await this.mVault.decimals()).to.be.bignumber.equal(new BN(18));
        expect(await this.mockERC20.totalSupply()).to.be.bignumber.equal(this.value);
    });

    context('During the first decay period, ERC/LP tokens are added to the field', () => {
        beforeEach(async () => {
            await this.mockERC20.transfer(alice, '1000', {from: minter});
            await this.mockERC20.transfer(bob, '1000', {from: minter});
            await this.mockERC20.transfer(carol, '1000', {from: minter});

            //??? 这个 approver 是个true fales 的对象
            await this.mController.approveStrategy(this.mockERC20.address, this.Strategy.address)
            await this.mController.setStrategy(this.mockERC20.address, this.Strategy.address)

            let addr = await this.mController.strategies(this.mockERC20.address)
            expect(addr).to.equal(this.Strategy.address);

        });

        it("should have correct deposit", async () => {

            //approve 合约可操作的资产
            await this.mockERC20.approve(this.mVault.address, '1000', {from: bob});
            // await this.mController.balanceOf(this.mockERC20.address)

            await this.mVault.deposit("100", {from: bob});

            //token.balanceOf(address(this)).mul(min).div(max);
            let mBalance = await this.mVault.available()
            console.log("before earn  available", mBalance.toString());
        });

        it("should have correct earn", async () => {
            let controller = await this.mVault.controller()
            console.log("controller ", controller);
            //清空
            await this.mVault.earn()

            mBalance = await this.mVault.available()
            console.log("after earn available", mBalance.toString());


            mBalance = await this.mVault.balance()
            console.log("mBalance", mBalance.toString());

            let _balance = await this.mVault.available()

            mBalance = await this.mVault.balanceOf(bob)
            console.log("balanceOf", mBalance.toString());

            // await this.mVault.withdraw(mBalance,{from: bob})

            mBalance = await this.mockERC20.balanceOf(this.mVault.address)
            console.log("mVault balanceOf", mBalance.toString());

            mBalance = await this.mController.balanceOf(this.mockERC20.address)
            console.log("mController balanceOf", mBalance.toString());
        });

        it("should have correct withdraw", async () => {
            //approve 合约可操作的资产
            let _poolBalance = await this.mVault.balance()
            if (_poolBalance.toString() == "0") {
                await this.mockERC20.approve(this.mVault.address, '1000', {from: alice});
                await this.mVault.deposit("200", {from: alice});
                expect(await this.mVault.balance()).to.be.bignumber.equal("200");
            }
        });
    })


});


