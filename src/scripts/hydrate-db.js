/* global describe it artifacts, contract, assert */
const _ = require('underscore');

const EternalStorage = artifacts.require("EternalStorage")
const PropertyStorageProxy = artifacts.require("PropertyStorageProxy")
const StorageKeyLib = artifacts.require("StorageKeyLib")
const ProxyControllerKeyLib = artifacts.require("ProxyControllerKeyLib")
const PropertyManagementV1 = artifacts.require("PropertyManagementV1")
const PropertyConnectorV1 = artifacts.require("PropertyConnectorV1")
const PropertyControllerProxy = artifacts.require("PropertyControllerProxy")

const propertyList = [
  "6127 Kenwood",
  "5102 Applewood",
  "6901 Baconwood",
  "4296 Hardwood",
  "1402 Woodwood",
]

// NOTE: Tests seem to run better with async functions, while migrations seem
//  to run better with promises. 
module.exports = async (callback) => {
  // Connect the proxy to leech off the PropertyConnectorV1

  try {
    let propertyStorageProxy = await PropertyStorageProxy.deployed()
    propertyStorageProxy = 
      await _.extend(
        propertyStorageProxy, 
        PropertyManagementV1.at(propertyStorageProxy.address)
      )

    const controllerAddress = 
      await propertyStorageProxy.getProxyControllerAddress.call()
    const propertyConnectorV1 = await PropertyConnectorV1.deployed()
    console.log(`Set contoller Address:     ${propertyConnectorV1.address}`)
    console.log(`Current contoller Address: ${controllerAddress}`)
    const weiCost = await propertyConnectorV1.getWeiCost.call(1);
    console.log(`weiCost: ${weiCost}`);
    let success
    for(let property of propertyList) {
      success = await propertyConnectorV1.createDefaultProperty(property)
      console.log(`${success ? 'Successfully' : 'Unsuccessfully'} 
        created property: ${property}`)
    }
  } catch(e) {
    console.log(e);
    console.log(`The error message: ${e.message}`);
  }

  // for(let property of propertyList) {
  //   await propertyConnectorV1.createDefaultProperty(property)
  // }

  // const controllerAddress = await propertyStorageProxy.getProxyControllerAddress.call()
  // console.log(`Contoller Address: ${controllerAddress}`)
  // const propertyConnectorV1 = await PropertyConnectorV1.deployed()
  // assert.equal(propertyConnectorV1.address, controllerAddress, "These addresses do not match")
  // // NOTE: Left off here
  // // await propertyStorageProxy.setProxyControllerAddress(0xbd2c938b9f6bfc1a66368d08cb44dc3eb2ae27bc)

  // await propertyConnectorV1.createDefaultProperty("100_Bryce");
  // let name = await propertyStorageProxy.getPropertyNameAtID(1);
  // console.log(`StorageProxy: ${name}`)    

  callback()
}
