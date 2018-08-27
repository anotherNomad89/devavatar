Given that the contracts are based upon open-source and peer reviewed code from the likes of Open-Zeppelin, EIP contributors and Live Smart Contracts on the Mainnet - we have reasonable cause to believe that the smart contracts are of substantial security standard.

In building my implementation I followed the principle of of least modification to the underlying code - such that I minimize the risk surface area.

As this is meant to be a publicly accessible smart contract - primarily for developers, no administrator priveleges have been implemented. With regards to the default child token contract - only the parent contract may invoke the mint method.

The assumption of the environment is that of good actors only - therefore I have even omitted an emergency stop function. Since there is no collateral loss of financial value on rinkeby, the security concerns are much reduced.

It is not intended for DevAvatar to be launched on the Mainnet - the transaction costs make it more prohibitive than it should be. And as developers, one should be able to collect rinkeby ether in order to participate on the "developers" blockchain.

The intention of the platform is as a meeting point for developers, where interactions may be tokenized for the sake of growing popularity of developers on Rinkeby.
