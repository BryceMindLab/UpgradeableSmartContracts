# Upgradeable Solidity Smart Contracts (with simple React front-end)
The purpose of this repository is to demonstrate how to develop upgradeable smart contracts.

## Dependencies 
Truffle v4.1.12 
Node v8.11.3

## To Run
Once Truffle and Node are installed:

1. Navigate to project dir via terminal
2. run truffle develop -Starts a development blockchain which will allow you to "migrate" the smart contracts onto
3. run `compile` -Compiles all the smart contracts into their respective "ABIs"
4. run `migrate` -Migrate the contracts onto the development server
5. In a separate terminal tab/window navigate to the project dir and run npm run start -This will start a development server which you can access via localhost:3000in your browser
6. Setup MetaMask (below)

## MetaMask
MetaMask is an Ethereum wallet Chrome extension, which makes it easy to process transactions in browser. To interact with the application, this extension needs to be *installed and setup properly.* Out of the box it is setup to connect to the main Ethereum network, but we want it to interact with our local development blockchain.

### Setup MetaMask
1. Install the "MetaMask" Chrome Extension 
2. Once installed, open up MetaMask and locate 'Main Ethereum Network' at the top. Click on this to open up other network options.
3. At the bottom you should see 'Custom RPC.' Click on this item.
4. Under 'New RPC URL' input the address: `http://localhost:9545` then 'save.' (This is the port that the development chain *should* be running on)
5. At this point MetaMask should connect to your development blockchain if it's running.
6. Logout of MetaMask, then "Import using account seed phrase," using the seed phrase of the development blockchain. This seed phrase is normally given in the console when the development blockchain started.  
7. Now that MetaMask is setup on the private network, the front-end can send and recieve data from the blockchain. Also, your newly created account from the development blockchain seed phrase gives you access to test funds.