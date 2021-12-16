# The BitSong Big Bang Testnet

**WARNING: USE THESE INSTRUCTIONS ONLY ON A NEW MACHINE WHICH IS NOT THE ONE RELATED TO BITSONG MAINNET**

**Currently it is highly NOT recommended to create a validator node and connect it to the testnet**

## Endpoints

- Faucet - https://faucet.testnet.bitsong.network
- RPC - https://rpc.testnet.bitsong.network
- API - https://api.testnet.bitsong.network
- Persistent peers - `4336c0f749d804d77a36534fbe37e5e85606a1ff@78.47.82.185:26656`
- Chain id - `bigbang-test-2`
- Genesis - `https://raw.githubusercontent.com/bitsongofficial/networks/master/testnet/bigbang-test-2/genesis.json`

## Install `go-bitsong`

### Pre-requisites

- Ubuntu 20.04
- Golang v1.17
- Git

### From Source

Open a new terminal and clone the `go-bitsong` repository

```bash=
git clone https://github.com/bitsongofficial/go-bitsong.git
```

Change to the repository directory

```bash=
cd go-bitsong
```

Checkout the `testnet` release

```bash=
git checkout testnet
```

Install `go-bitsong`

```bash=
make install
```

## Generate your keys

```bash=
bitsongd keys add user --keyring-backend test
```

**DO NOT FORGET TO SAVE YOUR MNEMONIC ONLY FOR THIS TESTNET**
Save your address and then request some token from faucet

## Faucet

### GET TOKEN FROM FAUCET

```bash
curl -X POST -d '{"address": "bitsong1ljga25xfqfpdqx3h5v2zv8cax0nr6jdl95qga8"}' https://faucet.testnet.bitsong.network
```

## Fantoken

### Query fantoken params

```bash=
bitsongd query fantoken params \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Issue a new fantoken

```bash=
bitsongd tx fantoken issue \
--name "Angelo's Fantoken" \
--symbol "angelo" \
--max-supply "1000000000" \
--issue-fee 1000000ubtsg \
--description "The most popular fantoken" \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443
```

### Query fantoken by denom

```bash=
bitsongd query fantoken denom ftA6822861D4003A3D13C2A9D46680750130579AE9 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Query fantoken by owner

```bash=
bitsongd query fantoken owner bitsong1nzxmsks45e55d5edj4mcd08u8dycaxq5eplakw \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Mint a fantoken

```bash=
bitsongd tx fantoken mint ft00CFD85F5B2EB9065E45D5CAD6FC9E74786D9708 \
--recipient $(bitsongd keys show user1 -a --home ./data/localnet --keyring-backend test) \
--amount 1000 \
--chain-id localnet \
--from user1 \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443
```

### Burn a fantoken

```bash=
bitsongd tx fantoken burn ft00CFD85F5B2EB9065E45D5CAD6FC9E74786D9708 \
--amount 1 \
--chain-id localnet \
--from user1 \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443
```

### Edit a fantoken

**ATTENTION**: If you edit your fantoken to `--mintable false` it will no longer be possible to make it **mintable**

```bash=
bitsongd tx fantoken edit ft00CFD85F5B2EB9065E45D5CAD6FC9E74786D9708 \
--mintable true \
--chain-id localnet \
--from user1 \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443
```

### Transfer the fantoken creator ownership

```bash=
bitsongd tx fantoken transfer ft00CFD85F5B2EB9065E45D5CAD6FC9E74786D9708 \
--recipient $(bitsongd keys show user2 -a --home ./data/localnet --keyring-backend test) \
--chain-id localnet \
--from user1 \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443
```
