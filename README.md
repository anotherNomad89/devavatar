DevAvatar is a message board for Ethereum developers to "walk the walk" and not just "talk the talk"

By signing up, and minting their own ERC998 DevAvatar token - devs acknowledge their acceptance of the Crypto-cratic oath: to build a decentralized world.

An ethereum developer without their avatar on rinkeby is like an amateur tattoo artist who has never put a needle to raw skin

- I'm hoping this high rhetoric will encourage my peers to join my platform where we can figure out how to build the decentralized world we need: One package at a time
- I'm talking about getting web3 working with React, (Drizzle anyone?), how to Python the blockchain, figuring out how to encourage adoption by muggles, etc.

The code base:

With regret, some of the ui work is still in progress. The smart contracts are complete, however, and can be interacted with on Rinkeby at:
- 0x048193514fb5c23ece94c83797fc9a3ed0a612de

1. Connecting to the smart contracts:

Brief walkthrough to interact with the DevAvatar contract on Rinkeby

- git clone https:github.com/manusmrit/devavatar.git
- git checkout development
- git pull

- npm install remixd -g
- remixd -s ./path_to/DevAvatar/contracts

Please specify the exact path as on your system

- open a browser
- switch to Rinkeby test net
- fetch test net ether from https:faucet.rinkeby.io/
- navigate to https:remix.ethereum.org

- click the 'link' icon top left of the screen "Connect to Local Host"
- expand newly loaded localhost dropdown, navigate to DevAvatar.sol
- click the 'run' tab - top right
- beneath the 'DevAvatar' box, paste 0x048193514fb5c23ece94c83797fc9a3ed0a612de into the "Load contract from Address"; click "atAddress"
- a dropdown list will load below, expanding it reveals the smart contract abi
- feel welcome to create a few child tokens!

2 The Dapp:

Please note that as this project uses UPort, a metamask account on the Rinkeby test network will be needed to interact with the UI.

Please download the UPort App to you mobile or you wont be able to login into the dashboard.

Please collect some Rinkeby test ether for the account from which you will trigger the smart contract transactions from.

@notice that the UI will check if you already have a token with the current Rinkeby-Metamask account and redirect you to a dead end
Please try a different Rinkeby account with ether in this case

required packages:

- npm install truffle -g
- npm install ganache-cli -g

For running tests please launch an instance of ganache-cli from a terminal
Tests will be run on the virtual blockchain whereas the live contract will be polled for the UI

Then in project root folder do:

- edit the truffle.js file, insert your metamask mnemonic (for the account with testnet ether in it) and infura api access key for Rinkeby (if you dont have a local geth instance)
- if you dont have an access key please sign up for one on infura.io

Open a terminal and run:

- npm install
- truffle compile --reset
- truffle migrate --network rinkeby
- npm run start

Your browser should automatically load, from the login screen you may:

- click login and follow the instructions
- mint DevAvatar
- WIP: mint child token, transfer child tokens, user posts..

Reference Material:

# truffle-uport-drizzle-react-materialui-starter

This repo started as a two truffle boxes:

- Drizzle Truffle Box: https://github.com/truffle-box/drizzle-box
- Uport Box http://truffleframework.com/boxes/react-uport
