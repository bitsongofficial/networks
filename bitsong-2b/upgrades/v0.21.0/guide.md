# Go-Bitsong v0.21.0 - Riverdale
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                  |
| Upgrade Version | `v0.21.0`                                             |
| Upgrade Height  | `TBD`                                                    |


The target block for this upgrade is `TBD`, which is expected to arrive at `Feb -th 2025, 06:10:38` [Mintscan Countdown](https://www.mintscan.io/bitsong/block/TBD)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.20.4) of `bitsongd`:

```sh
bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# client_name: bitsongcli
# version: 0.20.4
# commit:  
# build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `TBD`
```sh
perl -i -pe 's/^halt-height =.*/halt-height = TBD/' ~/.bitsongd/config/app.toml
```
then restart your node `systemctl restart bitsongd`

### 3. After the chain has halted, make a backup of your `.bitsongd` directory
```sh
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-1`.

 
### Option A: Install Go-Bitsong binary
```sh
cd go-bitsong && git pull && git checkout v0.21.0
make build && make install 
```

### 5. Verify you are currently running the correct version (v0.20.2) of the `go-bitsong`:
```sh
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: e49371a6876f650fc908ee376337606b2f57f3b5
# cosmos_sdk_version: v0.47.15
# version: 0.21.0
```

### Option B: Downloading Verified Build:
```sh
# set target platform
export PLATFORM_TARGET=amd64 #arm64
 # delete if exists
rm -rf bitsongd_linux_$PLATFORM_TARGET.tar.gz
# download 
curl -L -o ~/bitsongd-linux-$PLATFORM_TARGET.tar.gz https://github.com/bitsongofficial/go-bitsong/releases/download/v0.21.0/bitsongd-linux-$PLATFORM_TARGET.tar.gz
# verify sha256sum 
sha256sum bitsongd-linux-$PLATFORM_TARGET.tar.gz
# Output: e41e999624164a643d1b17be991fa5a0682be9af5232746bd8715a78ead98619  bitsongd-linux-amd64.tar.gz
# Output: 47bd2edd930fad101a0349b4a5e74986137d6524a6b1201d8c5055180204788a  bitsongd-linux-arm64.tar.gz

# decompress 
tar -xvzf bitsongd-linux-$PLATFORM_TARGET.tar.gz 

## move binary to go bin path
sudo mv build/bitsongd-linux-$PLATFORM_TARGET $HOME/go/bin/bitsongd

## change file ownership, if nessesary 
sudo chmod +x $HOME/go/bin/bitsongd

## confirm binary executable works 
bitsongd version --long 

# build_tags: netgo,ledger
# commit:   
# server_name: bitsongd
# version:0.21.0
```
 