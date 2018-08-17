/* global describe it artifacts */
const EternalStorage = artifacts.require("EternalStorage")
const PropertyStorageProxy = artifacts.require("PropertyStorageProxy")
const ProxyControllerKeyLib = artifacts.require("ProxyControllerKeyLib")
const PropertyConnectorV1 = artifacts.require("PropertyConnectorV1");

module.exports = async (deployer, network, accounts) => {
  let propertyConnectorV1;

  /*
  We are deploying PropertyConnector first because it's address is stored 
  in EternalStorage as the "proxyController." This ensures that only certain
  public proxy functions can be called by this contract and no others. 
  */
  deployer.deploy(PropertyConnectorV1).then(() => {
    return PropertyConnectorV1.deployed();
  }).then((instance) => {
    propertyConnectorV1 = instance;
    deployer.deploy(EternalStorage)
  }).then(() => {
    return deployer.deploy(ProxyControllerKeyLib)
  }).then(() => {
    return deployer.link(ProxyControllerKeyLib, PropertyStorageProxy)
  }).then(() => {
    return deployer.deploy(
      // The Storage Proxy Contract holds a pointer to the EternalStorage 
      //   contract and sets the Connector contract address as the proxyController
      PropertyStorageProxy, 
      EternalStorage.address,
      propertyConnectorV1.address
    )
  }).then(() => {
    return propertyConnectorV1.setInterface(PropertyStorageProxy.address)
  })
}
