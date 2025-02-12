# Go-Bitsong v0.21.0 - Riverdale
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                  |
| Upgrade Version | `v0.21.0`                                             |
| Upgrade Height  | `20960377`                                                    |


The target block for this upgrade is `20960377`, which is expected to arrive at `Feb 13th 2025, 10:47:59+00:00` [Mintscan Countdown](https://www.mintscan.io/bitsong/block/20960377)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.20.4) of `bitsongd`:

```sh
bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# client_name: bitsongcli
# version: 0.20.4
# commit: bc3863e2203bcdcf573cccb523088e431102049f
# build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `20960377`
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 20960377/' ~/.bitsongd/config/app.toml
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

### 5. Verify you are currently running the correct version (v0.20.5) of the `go-bitsong`:
```sh
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: 3f17bd7a6ab2b097237c0d15f73d103319df0d79  
# cosmos_sdk_version: v0.47.15
# version: 0.20.5
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
# Output: edcef92a51545e73f31d048482ebedee139cdf126f83a7a102334515ac2e93a8  bitsongd-linux-amd64.tar.gz
# Output: 3822fa98ef99bd3fb1b7855227781da710f6e98a469b56ba4c3c2239d34d611f  bitsongd-linux-arm64.tar.gz

# decompress 
tar -xvzf bitsongd-linux-$PLATFORM_TARGET.tar.gz 

## move binary to go bin path
sudo mv build/bitsongd-linux-$PLATFORM_TARGET $HOME/go/bin/bitsongd

## change file ownership, if nessesary 
sudo chmod +x $HOME/go/bin/bitsongd

## confirm binary executable works 
bitsongd version --long 

# build_tags: netgo,ledger
# commit: 8928250570ebdd5504f27b5ff6869f5f683a7515  
# name: go-bitsong
# server_name: bitsongd
# version:0.21.0
```
 