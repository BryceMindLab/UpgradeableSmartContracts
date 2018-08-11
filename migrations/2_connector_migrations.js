/* global describe it artifacts */
const PropertyControllerProxy = artifacts.require("PropertyControllerProxy");
const PropertyConnectorV1 = artifacts.require("PropertyConnectorV1");

// NOTE: Tests seem to run better with async functions, while migrations seem
//  to run better with promises.
// TODO: Seed the database here.
module.exports = async (deployer, network, accounts) => {
  // let propertyControllerProxy;

  deployer.deploy(PropertyConnectorV1)
  // .then(() => {
  //   return deployer.deploy(PropertyControllerProxy)
  // }).then(() => {
  //   return PropertyControllerProxy.deployed()
  // }).then((instance) => {
  //   propertyControllerProxy = instance
  //   return propertyControllerProxy.upgradeTo(PropertyConnectorV1.address)
  // }).then(() => {
  //   return propertyControllerProxy.implementation.call()
  // }).then((implementation) => {
  //   console.log(`***Confirmation of PropertyControllerProxy implementation address: ${implementation}`)
  // })
}

