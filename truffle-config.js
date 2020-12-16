require("dotenv").config()
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },
    rinkeby: {
        provider: function() {
            return new HDWalletProvider(
                process.env.MNEMONIC,
                'https://rinkeby.infura.io/v3/' + process.env.INFURA_ID
            );
        },
        network_id: '*'
    }
  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.6.10"
    }
  }
};
