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
      proxyInstance: null,
      propertyConnectorInstance: null,
      properties: [],
      controllerAddress: null,
      web3: null,
      intervalId: null
    }

    this.syncState = this.syncState.bind(this)
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      let web3 = results.web3
      web3.eth.deafaultAccount = web3.eth.accounts[0]
      this.setState({
        web3: results.web3
      })
  

      // Instantiate contract once web3 provided.
      return this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
    
    // Incase the database has already been hydrated we will sync first
    // await this.hydrateProperites();
    // await this.syncState();

  }

  componentDidMount() {
    this.syncState();
    var intervalId = setInterval(this.syncState, 1000*10);
    // store intervalId in the state so it can be accessed later:
    this.setState({intervalId: intervalId});
  }
  
  componentWillUnmount() {
    // use intervalId from the state to clear the interval
    clearInterval(this.state.intervalId);
  }

  async instantiateContract() {
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
    let proxyInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      propertyStorageProxy.deployed()
      .then((instance) => {
        console.log(`Proxy Instance: ${instance}`)
        // This is where the magic happens. 
        // Here we use 'underscores' extend method to leech the proxy onto 
        // the delegate 'propertyManagementV1' 
        proxyInstance = _.extend(instance, propertyManagementV1.at(instance.address))
        this.setState({proxyInstance: proxyInstance})
        // Setup the connector contract instance in state 
        return propertyConnectorV1.deployed()
      }).then((instance) => {
        console.log(`Connector Instance: ${instance}`)
        this.setState({propertyConnectorInstance: instance})
        return this.syncState()
      })
    })
  }

  // async hydrateProperites() {
  //   const { propertyConnectorInstance } = this.state
  //   if(propertyConnectorInstance) {
  //     for(let property of propertyList) {
  //       console.log(`Hydrating Database with property: ${property}`)
  //       await propertyConnectorInstance.createDefaultProperty(property)
  //     }
  //   } else {
  //     console.log("HydrateProperties: Missing contract instances!")
  //   }
  // }

  async syncState() {
    const { proxyInstance, propertyConnectorInstance } = this.state
    if(proxyInstance && propertyConnectorInstance) {
      const totalProperties = await proxyInstance.getTotalPropertyCount.call();
      if(totalProperties > 0) {
        this.setState({properties: []});
        // Properties are zero indexed so we can tell if they have been init'ed first
        for(var p=1; p<=totalProperties; p++) {
          const name = await proxyInstance.getPropertyNameAtID(p)
          const cost = await proxyInstance.getPropertyWeiCost(name)
          const property = {
            name,
            cost
          }
          this.setState({
            properties: [...this.state.properties, property]
          })
        }
      }
    } else {
      console.log("SyncState: Missing contract instances!")
    }
  }

  render() {
    const { properties } = this.state
    const propertyView = properties.map((property, index) => (
      <li key={index}>{`Property Name: ${property.name} Cost: ${property.cost}`}</li>
    ))

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
              <ul>
                {propertyView}
              </ul>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
