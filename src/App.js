import React, { Component } from 'react'
import getWeb3 from './utils/getWeb3'

import PropertyStorageProxy from '../build/contracts/PropertyStorageProxy.json'
import PropertyManagementV1 from '../build/contracts/PropertyManagementV1.json'
import PropertyConnectorV1 from '../build/contracts/PropertyConnectorV1.json'

import _ from 'underscore'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      controllerAddress: "",
      web3: null
    }
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    // Create a truffle contract abstraction with the contract artifacts
    const contract = require('truffle-contract')
    const propertyStorageProxy = contract(PropertyStorageProxy)
    const propertyManagementV1 = contract(PropertyManagementV1)
    const propertyConnectorV1 = contract(PropertyConnectorV1)

    // Set the web3 provider for each of the contracts
    propertyStorageProxy.setProvider(this.state.web3.currentProvider)
    propertyManagementV1.setProvider(this.state.web3.currentProvider)
    propertyConnectorV1.setProvider(this.state.web3.currentProvider)

    // Deployed instance vars so we can chain functions later.
    let proxyInstance, connectorInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      propertyStorageProxy.deployed().then((instance) => {
        console.log(`Proxy Instance: ${instance}`)
        // This is where the magic happens. 
        // Here we use 'underscores' extend method to leech the proxy onto 
        // the delegate 'propertyManagementV1' 
        proxyInstance = _.extend(instance, propertyManagementV1.at(instance.address))
        // Test that the proxy controller address returns successfully 
        return proxyInstance.getProxyControllerAddress.call()
      }).then((result) => {
        this.setState({controllerAddress: result})
      })
    })
  }

  render() {
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Good to Go!</h1>
              <p>Your Truffle Box is installed and ready.</p>
              <h2>Smart Contract Example</h2>
              <p>The controller address is: {this.state.controllerAddress}</p>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
