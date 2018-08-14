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

const weiToETH = 10**18

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      proxyInstance: null,
      propertyConnectorInstance: null,
      properties: [],
      inputs: [],
      controllerAddress: null,
      web3: null,
      intervalId: null
    }

    this.syncState = this.syncState.bind(this)
    this.updateCost = this.updateCost.bind(this)
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      let web3 = results.web3
      web3.eth.defaultAccount = web3.eth.accounts[0]
      this.setState({ web3 })
  

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
    var intervalId = setInterval(this.syncState, 1000*2);
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

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      propertyStorageProxy.deployed()
      .then((proxyInstance) => {
        console.log(`Proxy Instance: ${proxyInstance}`)
        // This is where the magic happens. 
        // Here we use 'underscores' extend method to leech the proxy onto 
        // the delegate 'propertyManagementV1' 
        proxyInstance = _.extend(proxyInstance, propertyManagementV1.at(proxyInstance.address))
        this.setState({proxyInstance: proxyInstance})
        // Setup the connector contract instance in state 
        return propertyConnectorV1.deployed()
      }).then((connectorInstance) => {
        console.log(`Connector Instance: ${connectorInstance}`)
        this.setState({propertyConnectorInstance: connectorInstance})
        return this.syncState()
      })
    })
  }

  async syncState() {
    const { proxyInstance, propertyConnectorInstance } = this.state
    if(proxyInstance && propertyConnectorInstance) {
      const totalProperties = await proxyInstance.getTotalPropertyCount.call();
      if(totalProperties > 0) {
        let { properties } = this.state
        // Properties are zero indexed so we can tell if they have been init'ed first
        for(var p=0; p<totalProperties; p++) {
          const id = p+1
          const name = await proxyInstance.getPropertyNameAtID(id)
          let cost = await proxyInstance.getPropertyWeiCost(name)
          cost /= weiToETH
          const property = {
            name,
            cost,
            id
          }
          properties[p] = property;
        }
        this.setState({ properties })
      }
    } else {
      console.log("SyncState: Missing contract instances!")
    }
  }

  // TODO: need to finish the logic here 
  async updateCost(event, index) {
    event.preventDefault()
    const { propertyConnectorInstance, properties, inputs } = this.state
    const weiCost = Number(inputs[index]) * weiToETH
    await propertyConnectorInstance.setWeiCost(properties[index].id, weiCost)
    inputs[index] = ''; 
    this.setState({inputs})
    await this.syncState()
  }

  handleChange(event, index) {
    const value = event.target.value
    let { inputs } = this.state
    inputs[index] = value
    this.setState({inputs})
  }

  render() {
    const { properties, inputs } = this.state
    const propertyView = properties.map((property, index) => (
      <li key={index}> 
        <div>
          <p>{`Name: ${property.name} Cost: ${property.cost} ETH`}</p>
            <form onSubmit={e => this.updateCost(e, index)}>
              <input 
                type="text" 
                name="newCost"
                value={inputs[index]}
                onChange={(e) => this.handleChange(e, index)}
              />
              <button>Submit New Cost</button>
            </form>
        </div>
      </li>
    ))

    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Crypto Real Estate</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Property Listings</h1>
              <p>Takea look at our properties and their costs.</p>
              <p>Change the value of each property as you please!</p>
              <h2>Property List:</h2>
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
