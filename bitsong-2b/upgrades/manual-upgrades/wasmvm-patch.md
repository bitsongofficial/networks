# `v0.21.4` - WasmVM Patch & Temp Dir Bug Resolution


|    |   |   |   |   |
|---|---|---|---|---|
| HALT HEIGHT  |    [`21051500`](https://www.mintscan.io/bitsong/block/21051500)  |   |   |   |
| HALT DATE (UTC)  | **Feb 19th 2025, `15:38:21+00:00`**   |   |   |   |
| Go-Bitsong Version  | [`v0.21.4`](https://github.com/bitsongofficial/go-bitsong/releases/tag/v0.21.4)   |   |   |   |

## Reasoning

### A. Wasm data directory migration
Upon upgrade to v0.50 of the cosmos-sdk, we also upgrade the wasVm to version `2.1.5`. This made our application expect the wasm data inside each node to exist in `$HOME/.bitsongd/wasm`, where prior to these upgrades, the wasm data path existed at `$HOME/.bitsongd/data/wasm`. This discrepency leads to application hash errors upon a full node recieving a cosmwasm transaction, and prevents queries for wasm data. 

### B. Recusive tempdir logic triggers node crash

Certain validators experienced a bug in how the tempdir cache is implemented, resulting in recusive calls to the logic, resulting in nodes crashing. To resolve this, we have implemented the patch in our [latest release](https://github.com/bitsongofficial/go-bitsong/releases/tag/untagged-7decc8281971a759a470) following this [identical bugs](https://github.com/cosmwasm/wasmd/issues/2017) resolution from gaia testnet, first discovered by [Quokka Stake](https://www.mintscan.io/bitsong/validators/bitsongvaloper14rvn7anf22e00vj5x3al4w50ns78s7n42rc0ge).

## Solution: Coordinated Halt For Block `21051500` & Upgrade 
By coordinating an halt height of `21051500`, updating nodes to the latest version, & moving the wasm data to the correct path if necessary, these issues are resolved as the vm is able to access the wasm state.

## Step 0: Set Halt Height
First, stop your node so that the halt height we are setting is applied to the runtime.
```sh
systemctl stop bitsongd.service 
# pkill -f bitsongd
```
Now, set the halt height in your nodes `app.toml`:
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 21051500/' ~/.bitsongd/config/app.toml
```

Once set, restart your nodes service:
```sh
systemctl start bitsongd.service
# bitsongd start --halt-height 21051500
```


## Step 1: Wait Until Consensus Reaching Block Height `21051500`
If you have set the halt height, your node should gracefully halt. Ensure you stop any service files while installing latest version and correcting wasm data path.
```sh
systemctl stop bitsongd.service
## pkill -f bitsongd
```

## Step 1.5 (optional): Backup `.bitsongd`
If you desire, cerate a bakcup of the data directory for redundancy:
```sh
cp -R $HOME/.bitsongd $HOME/.bitsongd.backup
```

## Step 2: Delete redundant wasm data dir
First step in correcting the wasm data directory location, we remove any data that exist in the path we are moving the wasm data to, preventing collision or overwriting of wasm files.
```sh
 rm -rf $HOME/.bitsongd/wasm
```

## Step 3: Copy existing wasm data to correct path
The next step is to move the wasm data into the directory location our VM expects it to be.
```sh
cp -R $HOME/.bitsongd/data/wasm $HOME/.bitsongd/wasm
```

## Step 4: Remove Redundant Wasm Data Dir
Finally, we remove the redundant wasm data, since we have moved it to the correct path.
```sh
rm -rf $HOME/.bitsongd/data/wasm
```

## Step 5: Install Latest Version 
Now, install the latest version of go-bitsong `v0.21.4`
```sh
cd go-bitsong
git fetch && git checkout v0.21.4
make install
# bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# version: 0.21.4
# commit : TBD
# build_tags: netgo,ledger
# go: go version go1.23
```

## Step 5.5: Remove halt height from `app.toml`:
With your node upgraded, before resuming consensus, ensure you remove the halt height from your `app.toml`
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 0/' ~/.bitsongd/config/app.toml
```

## Step 6: Resume Node Service
Once all steps are complete, you can now restart your node to resume consensus .
```sh
systemctl start bitsongd.service
# bitsongd start
```

## Step 5.5: Remove Backup Data Folder 
Ifyou created a backup, be sure to clean it up once you verify your patch was applied successfully.
```sh
rm -rf $HOME/.bitsongd.backup
```

*Please reach out in the validator chat if you run into issues*

### Extra: Confirm wasm now works 

You can run this query to confirm your nodes wasm directory path was updated as expected:
- API: `http://localhost:1317/cosmwasm/wasm/v1/contract/bitsong13z3y0leu0zjkupduqrfgzcthyqcj0h30mt75at63jyjhfvm2mzzq7n5mg9/smart/eyJudW1fdG9rZW5zIjp7fX0=`
- RPC: `bitsong q wasm contract-state smart bitsong13z3y0leu0zjkupduqrfgzcthyqcj0h30mt75at63jyjhfvm2mzzq7n5mg9 '{"num_tokens":{}}'`

Both queries should not error and provide a stateful response.