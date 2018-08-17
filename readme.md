# Upgradeable Solidity Smart Contracts <br/> (with simple React front-end)
The purpose of this repository is to demonstrate how to develop upgradeable smart contracts.

## Dependencies 
Truffle v4.1.12 
Node v8.11.3

## To Run
Once Truffle and Node are installed:

1. Navigate to project dir via terminal
2. run `truffle develop` -Starts a development blockchain which will allow you to "migrate" the smart contracts onto.
3. run `compile` -Compiles all the smart contracts into their respective "ABIs."
4. run `migrate` -Migrate the contracts onto the development server.
5. In a separate terminal tab/window navigate to the project dir and run `npm run start` -This will start a development server which you can access via `http://localhost:3000` in your browser
6. Setup MetaMask (below)

## MetaMask
MetaMask is an Ethereum wallet Chrome extension, which makes it easy to process transactions in browser. To interact with this application, this extension needs to be *installed and setup properly.* Out of the box it is setup to connect to the main Ethereum network, but we want it to interact with our local development blockchain.

### Setup MetaMask
1. Install the **MetaMask** Chrome Extension 
2. Once installed, open up MetaMask and locate **Main Ethereum Network** at the top. Click on this to open up other network options.
3. At the bottom click on **Custom RPC.**
4. Under **New RPC URL** input the address: `http://localhost:9545` then **save.**(This is the port that the development chain *should* be running on)
5. At this point MetaMask should connect to your development blockchain if it's running. Once MetaMask is setup on the private network, the front-end can send and recieve data from the blockchain.

### Setup Ethereum Test Account 
1. Logout of MetaMask, then click **Import using account seed phrase**. 
2. Find the seed phrase given from the development blockchain and use it to setup a new account. (This seed phrase is normally printed in the console when the development blockchain started.)  
3. Now you have access to test funds from your newly created account on the development blockchain.

# How the Contracts Interact
The workings of this proxy would not be possible without the knowledge gained from the following article: 
[How to write upgradable smart contracts in solidity!](https://medium.com/quillhash/how-to-write-upgradable-smart-contracts-in-solidity-d8f1b95a0e9a)

This repo was designed to take the idea of upgradeable smart-contracts one step further and add interface support so that large contracts can be split to meet gas constraints. 


Below you will find a visual of how all of the contracts interact together.

**Key:**
* Every rectange represents a different contract, with the contract name in bold at the top. _**PropertyStorageProxy** is also a separate contract, but it is used to 'leech' onto **PropertyManagementV1** and essentially become it._ 
* The **solid** arrows point to parent contracts of the originator. 
* The **dashed** arrows show where _pointers_ are stored.   

First be aware that not ALL of these contracts are upgradeable. 
**`EternalStorage`**, **`PropertyStorageProxy`**, and **`StorageState`** cannot be upgraded. Because of this, a key-value storage scheme is used in EternalStorage so that any type of data scheme can be used. All of these contracts work together to make access to **`EternalStorage`** possible. _All data in `EternalStorage` is stored in a mapping that maps `msg.sender` to the data so that external addresses cannot alter the data._

The rest of the contracts can be upgraded and hold the logic to make the DApp functional. 
 

![Contract Diagram](https://github.com/BryceDoganer/UpgradeableSmartContracts/blob/master/contract-diagram.png)

 