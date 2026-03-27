# Go-Bitsong v0.23.0 - Gauss
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                 |
| Upgrade Version | `v0.23.0`                                                    |
| Upgrade Height  | `22990737`                                                   |


The target block for this upgrade is `22990737`, which is expected to arrive at `Thursday June 26th 2025, 15:00:00 UTC` [Chainroot Countdown](https://explorer.chainroot.io/bitsong/blocks/22990737)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.22.0) of `bitsongd`:

```sh
bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# version: 0.22.0
# commit: 
# build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `22990737`
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 22990737/' ~/.bitsongd/config/app.toml
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
cd go-bitsong && git pull && git checkout v0.23.0
make install 
```

### 5. Verify you are currently running the correct version (v0.23.0) of the `go-bitsong`:
```sh
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: 831d0ee582d651e1dbc27715c740e38ad01225bc
# cosmos_sdk_version: v0.53.0
# version: v0.23.0
```

### Option B: Downloading Verified Build:
```sh
# set target platform
export PLATFORM_TARGET=amd64 #arm64
 # delete if exists
rm -rf bitsongd_linux_$PLATFORM_TARGET.tar.gz
# download 
curl -L -o ~/bitsongd-linux-$PLATFORM_TARGET.tar.gz https://github.com/bitsongofficial/go-bitsong/releases/download/v0.23.0/bitsongd-linux-$PLATFORM_TARGET.tar.gz
# verify sha256sum 
sha256sum bitsongd-linux-$PLATFORM_TARGET.tar.gz
# Output: 1f2338fbb93af915985293044d647b19b83b4c7da66f90b034f9c681b89d4fe9  bitsongd-linux-amd64.tar.gz
# Output: 80a7081968bc71b00c906518954776fea0c716e11c3149439bd85069f115172e  bitsongd-linux-arm64.tar.gz

# decompress 
tar -xvzf bitsongd-linux-$PLATFORM_TARGET.tar.gz 

## move binary to go bin path
sudo mv build/bitsongd-linux-$PLATFORM_TARGET $HOME/go/bin/bitsongd

## change file ownership, if nessesary 
sudo chmod +x $HOME/go/bin/bitsongd

## confirm binary executable works 
bitsongd version --long 

# build_tags: netgo,ledger
# commit: 831d0ee582d651e1dbc27715c740e38ad01225bc
# server_name: bitsongd
# version: v0.23.0
```

### Option C: Cosmovisor

