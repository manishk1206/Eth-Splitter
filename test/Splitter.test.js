const Splitter = artifacts.require("Splitter");
const truffleAssert = require('truffle-assertions');

contract("Splitter contract main test cases", accounts => {
    const [owner, account1, account2, account3] = accounts;
    let instance;
    
    beforeEach('Deploying fresh contract instance before each test', async function () {
        instance = await Splitter.new({from:owner});
    })
    
    it("Revert invalid attempts to split", async () => {
        const zerox = "0x0000000000000000000000000000000000000000";
        // revert zero address
        await truffleAssert.fails(
            instance.splitBalance(account2, zerox, { from: account1, value: 2 })
        );
        // revert zero value
        await truffleAssert.fails(
            instance.splitBalance(account2, account3, { from: account1, value: 0 })
        );
    });
    
    it("should split correctly when value is even", async () => {
        await instance.splitBalance(account2, account3, {from: account1, value:100})
        let balance1 = await instance.balances.call(account1);
        let balance2 = await instance.balances.call(account2);
        let balance3 = await instance.balances.call(account3);
    
        assert.strictEqual(balance1.toString(10), "0", "Account1 does not have the correct balance after splitting.");
        assert.strictEqual(balance2.toString(10), "50", "Account2 does not have the correct balance after splitting.");
        assert.strictEqual(balance3.toString(10), "50", "Account3 does not have the correct balance after splitting.");
    });
    
    it("should split correctly when value is odd", async () => {
        await instance.splitBalance(account2, account3, {from: account1, value:101})
        let balance1 = await instance.balances.call(account1);
        let balance2 = await instance.balances.call(account2);
        let balance3 = await instance.balances.call(account3);
    
        assert.strictEqual(balance1.toString(10), "1", "Account1 does not have the correct balance after splitting.");
        assert.strictEqual(balance2.toString(10), "50", "Account2 does not have the correct balance after splitting.");
        assert.strictEqual(balance3.toString(10), "50", "Account3 does not have the correct balance after splitting.");
    });
    
    
    it("Users can withdraw correctly and balances are updated in balances mapping", async () => {
        await instance.splitBalance(account2, account3, { from: account1, value: 2 });
    
        let account2Bal = await web3.eth.getBalance(account2);
        let withdrawal1 = await instance.withdrawFunds({ from: account2 });
        let tx1 = await web3.eth.getTransaction(withdrawal1.tx);
        let gasCost1 = tx1.gasPrice * withdrawal1.receipt.gasUsed;
        assert.equal(await instance.balances(account2, { from: account2 }), 0, "account2's post withdrawal balance should be 0");
        assert.equal(await web3.eth.getBalance(account2), (account2Bal - gasCost1 + 1), "account2 should have received Ether");
    
        let account3Bal = await web3.eth.getBalance(account3);
        let withdrawal2 = await instance.withdrawFunds({ from: account3 });
        let tx2 = await web3.eth.getTransaction(withdrawal2.tx);
        let gasCost2 = tx2.gasPrice * withdrawal2.receipt.gasUsed;
        assert.equal(await instance.balances(account3, { from: account3 }), 0, "account3's post withdrawal balance should be 0");
        assert.equal(await web3.eth.getBalance(account3), (account3Bal - gasCost2 + 1), "account3 should have received Ether");
    });
});
