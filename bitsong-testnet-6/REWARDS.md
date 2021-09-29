![](https://i.imgur.com/47tp5m9.jpg)

# bitsong-testnet-6 incentivized (phase 1)

We are pleased to inform you that the bitsong-testnet-6 was launched and is waiting to be "populated" by all of you Validators of the bitsong-1 Mainnet.

The Testnet is incentivized with **5000 BTSG** for each validator that completes a series of 12 tasks, which are reported below! Remember that in order to participate, it is mandatory to be validators of our current mainnet (bitsong-1).

Beside the testnet, the new Wallet (Beta) was also launched, through which it will be possible to interact with the blockchain quickly and easily. As the Wallet is freshly developed and as we want to launch it in Mainnet (bitsong-2) to facilitate user experience, please report bugs or malfunctions that you may find in it.

It is also also compatible with Keplr, so it makes it possible to view the balances contained in the Bitsong wallets you have connected to Keplr. It is also compatible with the Bitsong Ledger App, which will be officially published in the coming days, directly on the Ledger store.

- **https://wallet.testnet.bitsong.network/**

In the end, we remind you that the bitsong-2 through the [**Big Bang Upgrade**](https://bitsongofficial.medium.com/bitsong-launches-big-bang-upgrade-joining-the-ibc-enabled-blockchains-in-cosmos-802b73de6243), will contain many new features and improvements, including IBC, Fan token module, NFT module, Liquidity Module, Ledger Auth. and many other things that will be included in the documentation that we will release in this regard in the days coming.

**Participation and correct execution of all tasks award**:

- 5000 BTSG

Once you completed all the tasks, submit your application by filling the [**Form**](https://forms.gle/Q9BVTJUbeMGdESA4A).

## Task 1: Installation

In order to launch Bitsong-2 we need to test the new version of `go-bitsong v0.8.0`, to do this please follow the instructions here https://github.com/bitsongofficial/networks/tree/master/bitsong-testnet-6

## Task 2: Check if your balance is correct

`bitsong-testnet-6` uses the exported state of bitsong-1 and migrated for bitsong-2. It is important to check if your balance corresponds to the mainnet one. The balance should correspond to the balance you have available in mainnet (delegations excluded)

```
bitsongd query bank balances bitsong166d42nyufxrh3jps5wx3egdkmvvg7jl6k33yut
```

you should get a result like this:

```
balances:
- amount: "11056567265833"
  denom: ubtsg
pagination:
  next_key: null
  total: "0"

```

## Task 3: Create Validator

In order to use the exported genesis of `bitsong-1`, we had to create and maintain a single validator, therefore, to participate in the Testnet you have to send the `create-validator` tx again, which is available here
https://github.com/bitsongofficial/networks/tree/master/bitsong-testnet-6#launch-your-validator

## Task 4: Vote to enable IBC

`bitsong-2` introduces IBC for the first time. As first step it is necessary to enable IBC through a governance proposal. The proposal is opened by us, so you simply need to vote on it.

**Remember: YOU ONLY HAVE 24 HOURS TIME TO VOTE**

```
bitsongd tx gov vote 2 yes --from <key-name> -b block --chain-id bitsong-testnet-6
```

## Task 5: Send btsg from bitsong to cosmoshub-testnet

Make your first interblockchain transaction! Send bitsong to a cosmos address. To do this use the following command

1. Install `gaia 5.05`

```
cd ~ && git clone --branch v5.0.5 https://github.com/cosmos/gaia
cd gaia && make install
gaiad config node https://rpc.testnet.cosmos.network:443
gaiad config chain-id cosmoshub-testnet
gaiad config broadcast-mode block
```

2. Generate a new `cosmos` account

```
gaiad keys add <key-name>
```

3. transfer btsg to your new cosmos address make sure to change `cosmos1xpj4wk3qx2pfqry3fvggye6pluua9m64jzk8np` with your new key

```
bitsongd tx ibc-transfer transfer transfer channel-3 cosmos1xpj4wk3qx2pfqry3fvggye6pluua9m64jzk8np 2000000ubtsg --from <key-name> -b block --chain-id bitsong-testnet-6
```

## Task 6: Get some faucet from cosmoshub-testnet

Request some test tokens to interact on cosmoshub-testnet, change `cosmos1xpj4wk3qx2pfqry3fvggye6pluua9m64jzk8np` with your cosmos testnet address

```
curl -X POST -d '{"address": "cosmos1xpj4wk3qx2pfqry3fvggye6pluua9m64jzk8np"}' https://faucet.testnet.cosmos.network
```

## Task 7: Add your liquidity pool

Add liquidity to the BTSG/PHOTON pool

```
gaiad tx liquidity deposit 10 1000000ibc/0089C53C77684D611D90E8C837B6C07E2E01858CE0ED98CA9154E6ECA50763C4,1000000uphoton --from <key-name>
```

## Task 8: Swap atom for btsg

Execute your first BTSG/PHOTON swap

```
gaiad tx liquidity swap 10 1 100000ibc/0089C53C77684D611D90E8C837B6C07E2E01858CE0ED98CA9154E6ECA50763C4 uphoton 1.01 0.003 --from <key-name>
```

## Task 9: Swap btsg for atom

Execute a new swap the other way around atom/btsg

```
gaiad tx liquidity swap 10 1 100000uphoton ibc/0089C53C77684D611D90E8C837B6C07E2E01858CE0ED98CA9154E6ECA50763C4 0.95 0.003 --from <key-name>
```

## Task 10: Remove your liquidity

Now remove liquidity from the pool

```
gaiad tx liquidity withdraw 10 1000pool3788463F94E17E139ACCD919A2840A63A767F5F90B325C4EC7938F73F941A3EB --from <key-name>
```

## Task 11: Send back your btsg from cosmoshub-testnet to bitsong

It's time to get some btsg back. You can do it with this command

```
gaiad tx ibc-transfer transfer transfer channel-158 bitsong1usppkq8egtclqp5yfrxqwfa6xv5tlzjj2el2gr 100ibc/0089C53C77684D611D90E8C837B6C07E2E01858CE0ED98CA9154E6ECA50763C4 --from <key-name> --gas 400000
```

## Task 12: Send some atom from cosmoshub-testnet to bitsong

Let's also try to transfer some atoms from `cosmoshub-testnet` to `bitsong-tesnet-6`.

```
gaiad tx ibc-transfer transfer transfer channel-158 bitsong1usppkq8egtclqp5yfrxqwfa6xv5tlzjj2el2gr 100uphoton --from <key-name> --gas 400000
```

Amazing! You have completed your tasks, fill out the **[module](https://forms.gle/Q9BVTJUbeMGdESA4A)** and indicate the txs of your tasks. The txs will be shortly analyzed and the prizes will be allocated in bitsong-2

Are you happy with the new Testnet? Vote **Yes** in the upgrade proposal launched in `bitsong-1`[TODO: open proposal]
