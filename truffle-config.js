const path = require("path");
require('dotenv').config();
const mnemonic = process.env.MNEMONIC;
const HDWalletProvider = require("truffle-hdwallet-provider");

// PrivateKeyProvider uses your private key sign the smart contract deployment transaction
let PrivateKeyProvider = require("truffle-privatekey-provider");
let privateKey = process.env.PRIVATE_KEY;

// Create your own key for Production environments (https://infura.io/)
const infura_api_key = process.env.INFURA_API_KEY;

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,     // Ganache-GUI
      //port: 8545,   // Ganache-CLI
      network_id: "*",
    },

    // SKALE Side-Chain
    // hd_wallet: {
    //     provider: new HDWalletProvider(mnemonic, "[YOUR_SKALE_CHAIN_ENDPOINT]"),
    //     gasPrice: 0,
    //     network_id: "*"
    // },
    // private_key: {
    //     provider: new PrivateKeyProvider(privateKey, "[YOUR_SKALE_CHAIN_ENDPOINT]"),
    //     gasPrice: 0,
    //     gas: 8000000,
    //     network_id: "*"
    // },

    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/' + process.env.infura_api_key)
      },
      network_id: '3',
      gas: 4465030,
      gasPrice: 10000000000,
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(mnemonic, 'https://kovan.infura.io/v3/' + process.env.infura_api_key)
      },
      network_id: '42',
      gas: 4465030,
      gasPrice: 10000000000,
    },
    rinkeby: {
      provider: () => new HDWalletProvider(process.env.mnemonic, "https://rinkeby.infura.io/v3/" + process.env.infura_api_key),
      network_id: 4,
      gas: 3000000,
      gasPrice: 10000000000
    },
    // main ethereum network(mainnet)
    main: {
      provider: () => new HDWalletProvider(process.env.mnemonic, "https://mainnet.infura.io/v3/" + process.env.infura_api_key),
      network_id: 1,
      gas: 3000000,
      gasPrice: 10000000000
    }
  }
};
