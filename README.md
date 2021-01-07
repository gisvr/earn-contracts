 

## 快速调试
1. 先在根目录下运行 ` remixd -s ./`
> remixd -s ./ --remix-ide https://remix.ethereum.org/
   
2. 启动remix, 打开 首页 在 File 点击 Connect to Localhost
> 在 remix-ide 中激活好 remixd插件 

3. 在 左侧 FILE EXPLORERS 中看到一个新增加的 localhost目录。 

开始使用 Remix 

##  部署
验证部署脚本
```
truffle develop
```

```
truffle migrate --network ropsten --reset
```

 

## 私有测试网络
### Ganache-cli
```js
    npm install -g ganache-cli
--debug

    npx ganache-cli -h 0.0.0.0 -p 8545  --deterministic --gasPrice 5e9 --gasLimit 20000000 -e 10000 --networkId 1337 --db ./ganache > gan.log & 

```

### builder
> 介绍：https://buidler.hardhat.org/buidler-evm
node 大于  12.0版本
```
    mkdir buidler && cd ./buidler
    npm init // 一致回车，不需要输入  
    npm install --save-dev @nomiclabs/buidler
    npm install --save-dev @nomiclabs/buidler-waffle
    npm install --save-dev "@nomiclabs/buidler-ethers@^2.0.0"

    npx builder // 选择 Create an empty buidler.config.js
    //在buidler目录下执行 挂起服务 
    npx builder node --hostname 0.0.0.0 --port 8555> node.log & //31373

    npm i --save ganache-cli 
    tail -f node.log

   "scripts": {
      "node": "npx builder node --hostname 0.0.0.0 --port 8545"
    },
```

PM2 ecosystem.config.js 配置
> pm2 ecosystem
> pm2 start npm -- run node 

```js
{
  apps : [{
    name: "ganache",
    script: "/usr/local/node/bin/ganache-cli",
    error_file:"./logs/app-err.log",
    out_file: "./logs/app-out.log", 
    args:"-h 0.0.0.0 -p 8555  --deterministic --gasPrice 5e9 --gasLimit 20000000 -e 10000 --networkId 1338 --db ./ganache"
  }]
}
```

.prettierrc
```
{
    "overrides": [
      {
        "files": "*.sol",
        "options": {
          "printWidth": 80,
          "tabWidth": 4,
          "useTabs": true,
          "singleQuote": false,
          "bracketSpacing": true,
          "explicitTypes": "always"
        }
      }
    ]
}
  ``


