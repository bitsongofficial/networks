# WasmVM Patch

## Reasoning

Upon upgrade to v0.50 of the cosmos-sdk, wealso upgrade the wasm vm to version `2.1.5`. This made our application expect the wasm data inside each node to exist in  `$HOME/.bitsongd/wasm`, where prior to these upgrades, the  wasm data path existed at `$HOME/.bitsongd/data/wasm`. This discrepency leads to application hash errors upon a full node recieving a cosmwasm transaction, and prevents queries for wasm data. 

## Solution
By moving the wasm data to the correct path, these issues are resolved as the vm is able to access the wasm state.

## Step 1: Stop Node 
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

## Step 4: Remove redundant wasm data dir
```sh
rm -rf $HOME/.bitsongd/data/wasm
```

## Step 5: Restart Node 
```sh
systemctl start bitsongd.service
# bitsongd start
```

## Step 5.5: Remove backup data folder 
```sh
rm -rf $HOME/.bitsongd.backup
```

*Please reach out in the validator chat if you run into issues*