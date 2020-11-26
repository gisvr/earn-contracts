const {projectId, adminKey} = require('/Users/liyu/Desktop/key/secrets.json');
const HDWalletProvider = require('@truffle/hdwallet-provider');
module.exports = {
  networks: {
    development: {
      protocol: 'http',
      host: 'localhost',
      port: 8545,
      gas: 5000000,
      gasPrice: 5e9,
      networkId: '*',
    },
    test: {
      protocol: 'http',
      host: 'localhost',
      port: 9555,
      gas: 5000000,
      gasPrice: 5e9,
      networkId: '4447',
    },
    ropsten: {
      provider: () => new HDWalletProvider(
          adminKey, `https://ropsten.infura.io/v3/${projectId}`
      ),
      networkId: 3,
      gasPrice: 10e9
  }
  },
};
