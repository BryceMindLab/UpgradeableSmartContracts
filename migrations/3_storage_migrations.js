/* global describe it artifacts */
const EternalStorage = artifacts.require("EternalStorage")
const PropertyStorageProxy = artifacts.require("PropertyStorageProxy")
const ProxyControllerKeyLib = artifacts.require("ProxyControllerKeyLib")
const PropertyControllerProxy = artifacts.require("PropertyControllerProxy");
const PropertyConnectorV1 = artifacts.require("PropertyConnectorV1");

module.exports = async (deployer, network, accounts) => {
  let propertyControllerProxy;
  let propertyConnectorV1;

  /*
  Deploy Enternal Storage, along with Proxy and Libs 
  */
  deployer.deploy(EternalStorage)
  .then(() => {
    return PropertyConnectorV1.deployed();
  }).then((instance) => {
    propertyConnectorV1 = instance;
    return deployer.deploy(ProxyControllerKeyLib)
  }).then(() => {
    return deployer.link(ProxyControllerKeyLib, PropertyStorageProxy)
  }).then(() => {
    return deployer.deploy(
      PropertyStorageProxy, 
      EternalStorage.address,
      propertyConnectorV1.address
    )
  }).then(() => {
    return propertyConnectorV1.setInterface(PropertyStorageProxy.address)
  })
}
