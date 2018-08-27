var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "";

module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(
          mnemonic,
          "https://rinkeby.infura.io/YOUR_API_KEY"
        );
      },
      network_id: 4,
      gas: 7000000
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 500
    }
  }
};
