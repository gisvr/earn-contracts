const HDWalletProvider = require("@truffle/hdwallet-provider");

const {projectId,projectId1, privateKeys, etherscanKey} = require("/Users/liyu/Desktop/key/secrets.json");


module.exports = {
    migrations_directory: "./migrations/comp",
    api_keys: {
        etherscan: etherscanKey
    },
    networks: {
        private: {
            provider: () => new HDWalletProvider(privateKeys, `http://127.0.0.1:8000`),
            // host: "47.242.65.230",     // Localhost (default: none)
            // port: 8545,            // Standard Ethereum port (default: none)
            network_id: "*",       // Any network (default: none)
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            gas: 80000000,
            gasPrice: 20000000
            // skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
        },
        development: {host: "127.0.0.1", port: 8545, network_id: "*"},

        ropsten: {
            provider: () => new HDWalletProvider(privateKeys, `https://ropsten.infura.io/v3/${projectId}`),
            network_id: 3,       // Ropsten's id
            gas: 2e6,        // Ropsten has a lower block limit than mainnet
            gasPrice:6e9,
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
        },

        rinkeby: {
            provider: () => new HDWalletProvider(privateKeys, `https://rinkeby.infura.io/v3/${projectId}`),
            network_id: 4,       // Ropsten's id
            gas: 6700000,
            confirmations: 0,    // # of confs to wait between deployments. (default: 0)
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
        },

        mainnet: {
            provider: () => new HDWalletProvider(privateKeys, `https://mainnet.infura.io/v3/${projectId}`),
            network_id: 1,       // Ropsten's id
            gas: 5500000,        // Ropsten has a lower block limit than mainnet
            confirmations: 0,    // # of confs to wait between deployments. (default: 0)
            timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
            skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
        },
    },

    // Set default mocha options here, use special reporters etc.
    mocha: {
        timeout: 100000
    },

    // Configure your compilers
    compilers: {
        solc: {
            version: "0.6.12",    // Fetch exact version from solc-bin (default: truffle's version)
            // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
            settings: {          // See the solidity docs for advice about optimization and evmVersion
                optimizer: {
                    enabled: true,
                    runs: 200
                },
                //  evmVersion: "byzantium"
            }
        }
    },
    plugins: [
        'truffle-plugin-verify'
    ]
}
