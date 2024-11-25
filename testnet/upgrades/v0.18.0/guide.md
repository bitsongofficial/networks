# Go-Bitsong v0.18.0 - Babberitus
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                  |
| Upgrade Version | `v0.18.0`                                                     |
| Upgrade Height  | `19818776`                                                    |



The target block for this upgrade is `19818776`, which is expected to arrive at `11/29/2024` [Go Playground](https://go.dev/play/p/UmBiC53Bc51)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.17.0) of `bitsongd`:

```sh
bitsongd version --long
# name: go-bitsong
# server_name: bitsongd
# client_name: bitsongcli
# version: 0.17.0
# commit: 6caaf5fdba8e7ce41e8a9d44654c141f85c9c38f
# build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `19818776`
```sh
perl -i -pe 's/^halt-height =.*/halt-height = 19818776/' ~/.bitsongd/config/app.toml
```
then restart your node `systemctl restart bitsongd`

### 3. After the chain has halted, make a backup of your `.bitsongd` directory
```sh
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-1`.


### 4. Update Go

```sh
wget -q -O - https://git.io/vQhTU | bash -s -- --remove
wget -q -O - https://git.io/vQhTU | bash -s -- --version 1.22.4
```

### Option A: Install Go-Bitsong binary
```sh
cd go-bitsong && git pull && git checkout v0.18.0
make build && make install 
```

### 5. Verify you are currently running the correct version (v0.18.0) of the `go-bitsong`:
```sh
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: 
# cosmos_sdk_version: v0.47.8
# version: 0.18.0
```

### Option B: Downloading Verified Build:
```sh
# set target platform
export PLATFORM_TARGET=amd64
 # delete if exists
rm -rf bitsongd_linux_$PLATFORM_TARGET.tar.gz
# download 
curl -L -o ~/bitsongd-linux-arm64.tar.gz https://github.com/permissionlessweb/go-bitsong/releases/download/v0.18.1/bitsongd-linux-$PLATFORM_TARGET.tar.gz
# verify sha256sum 
sha256sum bitsongd-linux-$PLATFORM_TARGET.tar.gz
# Output  d8dd5c1d371153d983abe1ce4f41543de5f498a7397c79d81600adc0394d36cc  bitsongd-linux-amd64.tar.gz
# Output  dbf2dbf5851c241a0fc4ea449878633996fb3b7433b7bc817984e504c0342d22  bitsongd-linux-arm64.tar.gz

# decompress 
tar -xvzf bitsongd-linux-$PLATFORM_TARGET.tar.gz 

## move binary to go bin path
sudo mv build/bitsongd-linux-$PLATFORM_TARGET /usr/local/go/bitsongd

## change file ownership, if nessesary 
sudo chmod +x /usr/local/go/bitsongd

## confirm binary executable works 
bitsongd version --long 

# build_tags: netgo,ledger
# commit: cba10a529d1489b5a74b47b8dc5b8cc0fd92db39
# cosmos_sdk_version: v0.47.8
# go: go version go1.23.3 darwin/<you-platform>
# name: go-bitsong
# server_name: bitsongd
# version: 0.18.1
```

## Ensure Minimum Gas Config is set 
```sh
export DAEMON_HOME=$HOME/.bitsongd
sed 's/^minimum-gas-prices = .*/minimum-gas-prices = "0.06969ubtsg"/' $DAEMON_HOME/config/app.toml > temp_file && mv temp_file $DAEMON_HOME/config/app.toml
```