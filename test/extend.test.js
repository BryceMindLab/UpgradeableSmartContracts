/* global describe it artifacts, contract, assert */

/*
What makes Truffle tests different from that of Mocha is the contract() 
function: This function works exactly like describe() except it enables 
Truffle's clean-room features. It works like this:

  *Before each contract() function is run, your contracts are redeployed to the 
running Ethereum client so the tests within it run with a clean contract state.

  *The contract() function provides a list of accounts made available by your 
Ethereum client which you can use to write tests.

USING WEB3
A web3 instance is available in each test file, 
configured to the correct provider. So calling web3.eth.getBalance just works!
*/
const EternalStorage = artifacts.require("EternalStorage")
const PropertyStorageProxy = artifacts.require("PropertyStorageProxy")
const StorageKeyLib = artifacts.require("StorageKeyLib")
const ProxyControllerKeyLib = artifacts.require("ProxyControllerKeyLib")
const PropertyManagementV1 = artifacts.require("PropertyManagementV1")
const PropertyConnectorV1 = artifacts.require("PropertyConnectorV1")
const PropertyControllerProxy = artifacts.require("PropertyControllerProxy")

// NOTE: Tests seem to run better with async functions, while migrations seem
//  to run better with promises. 
contract('Proxy contract test', async (accounts) => {

  it("should allow us to set and retireve the proxyControllerAdress", async () => {
    // let propertyStorageProxy
    // let propertyManagementV1
    // let propertyControllerProxy

    // PropertyStorageProxy.deployed()
    // .then((instance) => {
    //   propertyStorageProxy = instance
    //   return PropertyManagementV1.deployed()
    // }).then((instance) => {
    //   propertyManagementV1 = instance
    //   return _.extend(propertyStorageProxy, propertyManagementV1.at(propertyStorageProxy.address))
    // }).then((instance) => {
    //   propertyStorageProxy = instance
    //   return PropertyControllerProxy.deployed();
    // }).then((instance) => {
    //   propertyControllerProxy = instance
    //   return propertyStorageProxy.setProxyControllerAddress(propertyControllerProxy.address)
    // }).then(() => {
    //   return propertyStorageProxy.getProxyControllerAddress()
    // }).then((controllerAddress) => {
    //   console.log(`Contoller Address: ${controllerAddress}`)
    //   asset.equal(propertyControllerProxy.address, 0x00, "These addresses do not match")
    // })

    // Connect the proxy to leech off the PropertyConnectorV1
    let propertyStorageProxy = await PropertyStorageProxy.deployed()
    propertyStorageProxy = _.extend(propertyStorageProxy, PropertyManagementV1.at(propertyStorageProxy.address))
    
    const controllerAddress = await propertyStorageProxy.getProxyControllerAddress.call()
    console.log(`Contoller Address: ${controllerAddress}`)
    const propertyConnectorV1 = await PropertyConnectorV1.deployed()
    assert.equal(propertyConnectorV1.address, controllerAddress, "These addresses do not match")
    // NOTE: Left off here
    // await propertyStorageProxy.setProxyControllerAddress(0xbd2c938b9f6bfc1a66368d08cb44dc3eb2ae27bc)

    await propertyConnectorV1.createDefaultProperty("100_Bryce");
    let name = await propertyStorageProxy.getPropertyNameAtID(1);
    console.log(`StorageProxy: ${name}`)
    
    // await propertyConnectorV1.setWeiCost(0, 100)
    // let cost = await propertyConnectorV1.getWeiCost(0);
    // console.log(`Returned Cost: ${cost}`);
    // assert.equal("Bryce", name, "These addresses do not match")
  })


  // it("should call a function that depends on a linked library", async () => {
  //   let meta = await MetaCoin.deployed();
  //   let outCoinBalance = await meta.getBalance.call(accounts[0]);
  //   let metaCoinBalance = outCoinBalance.toNumber();
  //   let outCoinBalanceEth = await meta.getBalanceInEth.call(accounts[0]);
  //   let metaCoinEthBalance = outCoinBalanceEth.toNumber();
  //   assert.equal(metaCoinEthBalance, 2 * metaCoinBalance);

  // });

  // it("should send coin correctly", async () => {

  //   // Get initial balances of first and second account.
  //   let account_one = accounts[0];
  //   let account_two = accounts[1];

  //   let amount = 10;


  //   let instance = await MetaCoin.deployed();
  //   let meta = instance;

  //   let balance = await meta.getBalance.call(account_one);
  //   let account_one_starting_balance = balance.toNumber();

  //   balance = await meta.getBalance.call(account_two);
  //   let account_two_starting_balance = balance.toNumber();
  //   await meta.sendCoin(account_two, amount, {from: account_one});

  //   balance = await meta.getBalance.call(account_one);
  //   let account_one_ending_balance = balance.toNumber();

  //   balance = await meta.getBalance.call(account_two);
  //   let account_two_ending_balance = balance.toNumber();

  //   assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
  //   assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
  // });

})
