/* global describe it artifacts */
const StorageKeyLib = artifacts.require("StorageKeyLib")
const ProxyControllerKeyLib = artifacts.require("ProxyControllerKeyLib")
const PropertyManagementV1 = artifacts.require("PropertyManagementV1")
const PropertyStorageProxy = artifacts.require("PropertyStorageProxy")

module.exports = async (deployer, network, accounts) => {
  let propertyStorageProxy
  /*
  PropertyManagementV1 plus Libs  
  */
  // Deploy and link lib to PropertyManagementV1
  deployer.deploy(ProxyControllerKeyLib)
  .then(() => {
    return deployer.link(ProxyControllerKeyLib, PropertyManagementV1)
  }).then(() => {
    // Deploy and link  lib to PropertyManagementV1
    return deployer.deploy(StorageKeyLib)
  }).then(() => {
    return deployer.link(StorageKeyLib, PropertyManagementV1)
  }).then(() => {
    // PropertyManagement can be deployed now
    return deployer.deploy(PropertyManagementV1)
  }).then(() => {
    return PropertyStorageProxy.deployed()
  }).then((instance) => {
    propertyStorageProxy = instance
    return propertyStorageProxy.upgradeTo(PropertyManagementV1.address)
  }).then(() => {
    return propertyStorageProxy.implementation()
  }).then((implementation) => {
    console.log(`***Confirmation of PropertyStorageProxy implementation address: ${implementation}`)
  })
}
