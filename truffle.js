module.exports = {
  networks: {
    development: {
      host: "localhost",
      // port: 8545,
      port: 9545, // Truffle Develop
      network_id: "*" // Match any network id
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 500
    }
  },
  mocha: {
    reporter: 'eth-gas-reporter',
    reporterOptions : {
      currency: 'CHF',
      gasPrice: 21
    }
  }
};
