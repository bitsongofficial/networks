# Go-Bitsong v0.20.2 - Retune
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                  |
| Upgrade Version | `v0.20.2`                                             |
| Upgrade Height  | `20277056`                                                    |


The target block for this upgrade is `20277056`, which is expected to arrive at `Dec 30th 2024, 06:10:38` [Mintscan Countdown](https://www.mintscan.io/bitsong/block/20277056)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.19.0) of `bitsongd`:

```sh
bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# client_name: bitsongcli
# version: 0.19.0
# commit: 5960e1c90a3dce23ff950261cb720b53f2dfe70c
# build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `20277056`
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 20277056/' ~/.bitsongd/config/app.toml
```
then restart your node `systemctl restart bitsongd`

### 3. After the chain has halted, make a backup of your `.bitsongd` directory
```sh
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-1`.

 
### Option A: Install Go-Bitsong binary
```sh
cd go-bitsong && git pull && git checkout v0.20.2
make build && make install 
```

### 5. Verify you are currently running the correct version (v0.20.2) of the `go-bitsong`:
```sh
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: <TBD>
# cosmos_sdk_version: v0.47.15
# version: 0.20.2
```

### Option B: Downloading Verified Build:
```sh
# set target platform
export PLATFORM_TARGET=amd64
 # delete if exists
rm -rf bitsongd_linux_$PLATFORM_TARGET.tar.gz
# download 
curl -L -o ~/bitsongd-linux-$PLATFORM_TARGET.tar.gz https://github.com/bitsongofficial/go-bitsong/releases/download/v0.20.2/bitsongd-linux-$PLATFORM_TARGET.tar.gz
# verify sha256sum 
sha256sum bitsongd-linux-$PLATFORM_TARGET.tar.gz
# Output: <TBD>  bitsongd-linux-amd64.tar.gz
# Output: <TBD>  bitsongd-linux-arm64.tar.gz

# decompress 
tar -xvzf bitsongd-linux-$PLATFORM_TARGET.tar.gz 

## move binary to go bin path
sudo mv build/bitsongd-linux-$PLATFORM_TARGET /usr/local/go/bitsongd

## change file ownership, if nessesary 
sudo chmod +x /usr/local/go/bitsongd

## confirm binary executable works 
bitsongd version --long 

# build_tags: netgo,ledger
# commit: <TBD>
# server_name: bitsongd
# version: v0.20.2
```

### Optional Build Version 
A version of go-bitsong that will print a file with the delegations claimed is available under the `v0.20.1-print` branch. Feel free to use this version during the upgrade.