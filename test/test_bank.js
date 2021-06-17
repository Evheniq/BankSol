const Bank = artifacts.require("Bank");
// require("chai").use(require("chai-bignumber")(web3.BigNumber)).should();

contract("Bank", function([ownerContract, creditClient, depositClient]) {

const ETHERS = 10**18;
const GAS_PRICE = 10**6;

// let bankContract = null;

//   it("should check the donate", async () => {
//     bankContract = await Bank.deployed();
//     const owner = await bankContract.owner.call();
//     owner.should.be.equal(ownerContract);
//   });

    it("should accept deposit", async () => {
        const bdepositClient = web3.eth.getBalance(depositClient);

        await Bank.deposit({ 
            from: depositClient, 
            value: 20 * ETHERS, 
            gasPrice: GAS_PRICE 
        });

        const deposited = await Bank.returnDeposit();
        deposited.should.be.equal(20 * ETHERS);
    });

});