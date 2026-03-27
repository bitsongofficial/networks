# Go-Bitsong v0.22.0 - Nina
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                  |
| Upgrade Version | `v0.22.0`                                             |
| Upgrade Height  | `22412000`                                                    |


The target block for this upgrade is `22412000`, which is expected to arrive at `May 19th 2025, 15:38:25 UTC` [Mintscan Countdown](https://www.mintscan.io/bitsong/block/22412000)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.21.6) of `bitsongd`:

```sh
bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# client_name: bitsongcli
# version: 0.21.6
# commit: fbdc84594b0a65d2bbe1da4381f71932efa7efed
# build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `22412000`
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 22412000/' ~/.bitsongd/config/app.toml
```
then restart your node `systemctl restart bitsongd`

### 3. After the chain has halted, make a backup of your `.bitsongd` directory
```sh
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-2b`.
~z
 
### Option A: Install Go-Bitsong binary
```sh
git clone https://github.com/permissionlessweb/go-bitsong
cd go-bitsong && git pull && git checkout v0.22.0
make install 
```

### 5. Verify you are currently running the correct version (v0.20.2) of the `go-bitsong`:
```sh
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: 424ccd2affd7274a6befcdb99079d1f05fab6e86
# cosmos_sdk_version: v0.53.0
# version: 0.22.0
```

### Option B: Downloading Verified Build:
```sh
# set target platform
export PLATFORM_TARGET=amd64 #arm64
 # delete if exists
rm -rf bitsongd_linux_$PLATFORM_TARGET.tar.gz
# download 
curl -L -o ~/bitsongd-linux-$PLATFORM_TARGET.tar.gz https://github.com/bitsongofficial/go-bitsong/releases/download/v0.22.0/bitsongd-linux-$PLATFORM_TARGET.tar.gz
# verify sha256sum 
sha256sum bitsongd-linux-$PLATFORM_TARGET.tar.gz
# Output: 810188661f98a75941de3a0d3671a7ec40e19824b93ab1f9204ac585300537de  bitsongd-linux-amd64.tar.gz
# Output: 4dcf0f96d83613620e3e2ea6e037de0400c732ee4ce6a176b517e42b8a4f2721  bitsongd-linux-arm64.tar.gz

# decompress 
tar -xvzf bitsongd-linux-$PLATFORM_TARGET.tar.gz 

## move binary to go bin path
sudo mv build/bitsongd-linux-$PLATFORM_TARGET $HOME/go/bin/bitsongd

## change file ownership, if nessesary 
sudo chmod +x $HOME/go/bin/bitsongd

## confirm binary executable works 
bitsongd version --long 

# build_tags: netgo,ledger
# commit: 424ccd2affd7274a6befcdb99079d1f05fab6e86
# server_name: bitsongd
# version:0.22.0
```

### Option C: Cosmovisor

