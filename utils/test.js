let provider = require("./ganache.provider");


(async () => {
    const web3 = provider.getWeb3();
    let foo = await web3.eth.getChainId();
    console.log(foo.toString())
    let mController =await provider.getArttifact("mController");
    console.log(mController.address);
})()

