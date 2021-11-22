# The BitSong Big Bang Testnet

**WARNING: USE THESE INSTRUCTIONS ONLY ON A NEW MACHINE WHICH IS NOT THE ONE RELATED TO BITSONG MAINNET**

**Currently it is highly NOT recommended to create a validator node and connect it to the testnet**

## Endpoints

- Faucet - https://faucet.testnet.bitsong.network
- RPC - https://rpc.testnet.bitsong.network
- API - https://api.testnet.bitsong.network
- Persistent peers - `2acc8a6528d453dce94d9a4ca2f2720ac0d61be9@34.77.153.153:26656`
- Chain id - `bigbang-test-1`
- Genesis - `TODO`

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

## NFT

### Issue a new NFT Denom

```bash=
bitsongd tx nft issue denom1 \
--name "My first denom" \
--creators $(bitsongd keys show angelo -a --keyring-backend test) \
--split-shares 100 \
--royalty-share 10 \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

~~### Edit a NFT (to remove???)~~

### Mint a new NFT to a recipient

```bash=
bitsongd tx nft mint denom1 10000 \
--name "My first NFT" \
--uri "ipfs://hash" \
--recipient $(bitsongd keys show angelo -a --keyring-backend test) \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

### Burn a NFT from user wallet

### Transfer NFT?

### Query nft collection by denom

```bash=
bitsongd query nft collection denom1 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Query nfts by denom

```bash=
bitsongd query nft denom denom1 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Query nfts by owner

```bash=
bitsongd query nft owner $(bitsongd keys show user1 -a --keyring-backend test) \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

Filter by owner and denom-id

```bash=
bitsongd query nft owner $(bitsongd keys show user1 -a --home ./data/localnet --keyring-backend test) \
--denom-id denom1 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Query nfts supply

```bash
bitsongd query nft supply denom1 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Query NFT by denom and token id

```bash
bitsongd query nft token denom1 10000 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

~~### Query nfts by denom-name (to remove)~~

~~### Query nfts denoms (to remove)~~

## NFT Marketplace

### Create new auction

```bash=
bitsongd tx auction open \
--auction-type 0 \
--nft-denom-id denom1 \
--nft-token-id 10000 \
--duration 86400 \
--min-amount 1000000ubtsg \
--limit 1 \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

### Edit auction

```bash=
bitsongd tx auction edit 1 \
--duration 10000 \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

### Cancel auction

```bash=
bitsongd tx auction cancel 1 \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

### Bid on auction

```bash=
bitsongd tx auction open-bid 1 \
--bid-amount 1000000ubtsg \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

### Cancel bid

```bash=
bitsongd tx auction cancel 1 \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

### Withdraw (nft/coins) from auction

```bash=
bitsongd tx auction withdraw 1 \
--chain-id bigbang-test-1 \
--from angelo \
-b block \
--keyring-backend test \
--node https://rpc.testnet.bitsong.network:443 -y | jq
```

### Query auction by id

```bash
bitsongd query auction id 1 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```

### Query bids by auction id

```bash
bitsongd query auction bids 1 \
--node https://rpc.testnet.bitsong.network:443 \
--output json | jq
```
