# `v0.21.4` - WasmVM Patch & Temp Dir Bug Resolution

## Reasoning

### A. Wasm data directory migration
Upon upgrade to v0.50 of the cosmos-sdk, we also upgrade the wasVm to version `2.1.5`. This made our application expect the wasm data inside each node to exist in  `$HOME/.bitsongd/wasm`, where prior to these upgrades, the  wasm data path existed at `$HOME/.bitsongd/data/wasm`. This discrepency leads to application hash errors upon a full node recieving a cosmwasm transaction, and prevents queries for wasm data. 

### B. Recusive tempdir logic triggers node crash

Certain validators experienced a bug in how the tempdir cache is implemented, resulting in recusive calls to the logic, resulting in nodes crashing. To resolve this, we have implemented the patch in our [latest release](https://github.com/bitsongofficial/go-bitsong/releases/tag/untagged-7decc8281971a759a470) following this [identical bugs](https://github.com/cosmwasm/wasmd/issues/2017) resolution from gaia testnet, first discovered by [Quokka Stake](https://www.mintscan.io/bitsong/validators/bitsongvaloper14rvn7anf22e00vj5x3al4w50ns78s7n42rc0ge).

## Solution: Coordinated Halt For Block `21051500` & Upgrade  
By coordinating an halt height of `21051500`, updating nodes to the latest version, & moving the wasm data to the correct path if necessary, these issues are resolved as the vm is able to access the wasm state.


## Step 0: Set Halt Height
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 21051500/' ~/.bitsongd/config/app.toml
```

## Step 1: Wait Until Consensus Reaching Block Height  `21051500`
```sh
systemctl stop bitsongd.service
## pkill -f bitsongd
```

## Step 1.5 (optional): Backup `.bitsongd`
```sh
cp -R $HOME/.bitsongd $HOME/.bitsongd.backup
```

## Step 2: Delete redundant wasm data dir
```sh
 rm -rf $HOME/.bitsongd/wasm
```

## Step 3: Copy existing wasm data to correct path
```sh
cp -R $HOME/.bitsongd/data/wasm  $HOME/.bitsongd/wasm
```

## Step 4: Remove Redundant Wasm Data Dir
```sh
rm -rf $HOME/.bitsongd/data/wasm
```

## Step 5: Install Latest Version 
```sh
cd go-bitsong
git fetch && git checkout v0.21.4
make install
# bitsongd version --long
#  name: go-bitsong
# server_name: bitsongd
# version: 0.21.4
# commit : TBD
# build_tags: netgo,ledger
# go: go version go1.23
```


## Step 6: Resume Node Service

```sh
systemctl start bitsongd.service
# bitsongd start
```

## Step 5.5: Remove Backup Data Folder 
```sh
rm -rf $HOME/.bitsongd.backup
```

*Please reach out in the validator chat if you run into issues*