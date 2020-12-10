let Web3 = require("web3");
// let host = "https://ropsten.infura.io/v3/393758f6317645be8a1ee94a874e12d9";
let host = "http://47.75.58.188:8545";


(async ()=>{
    const web3 = new Web3(host);
   let foo = await  web3.eth.getChainId();
   console.log(foo.toString())
})()

