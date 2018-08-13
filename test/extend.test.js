/* global describe it artifacts, contract, assert */
const _ = require('underscore');

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
    // Connect the proxy to leech off the PropertyConnectorV1
    // TODO: Change all `deployed()` to `new()`
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
})
