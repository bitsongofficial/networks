# Go-Bitsong v0.18.0 - Babberitus
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                  |
| Upgrade Version | `v0.18.0`                                                     |
| Upgrade Height  | `TBD`                                                    |



The target block for this upgrade is `TBD`, which is expected to arrive at TBD [Go Playground](https://go.dev/play/p/)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.17.0) of `bitsongd`:
```
bitsongd version --long
name: go-bitsong
server_name: bitsongd
client_name: bitsongcli
version: 0.17.0
commit: 6caaf5fdba8e7ce41e8a9d44654c141f85c9c38f
build_tags: netgo,ledger
```

### 2. Make sure your chain halts at the right block: `TBD`
```
perl -i -pe 's/^halt-height =.*/halt-height = TBD/' ~/.bitsongd/config/app.toml
```
then restart your node `systemctl restart bitsongd`

### 3. After the chain has halted, make a backup of your `.bitsongd` directory
```
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-1`.


### 4. Update Go

```
wget -q -O - https://git.io/vQhTU | bash -s -- --remove
wget -q -O - https://git.io/vQhTU | bash -s -- --version 1.22.2
```

### Install Go-Bitsong binary
```
cd go-bitsong && git pull && git checkout v0.18.0
make build && make install 
```

### 5. Verify you are currently running the correct version (v0.18.0) of the `go-bitsong`:
```
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: 
# cosmos_sdk_version: v0.47.8
# version: 0.18.0

```
### Downloading Verified Build:
```sh
rm -rf bitsongd_linux_amd64.tar.gz # delete if exists
wget https://github.com/permissionlessweb/g o-bitsong/releases/download/v0.18.0/bitsongd-linux-amd64.tar
sha256sum bitsongd-linux-amd64.tar.gz
# Output  7c82e4ea00c94484366bae7fd6783a28414f22152513d1bac8f872242a35a37e  bitsongd-linux-amd64.tar.gz
# Output  4c07bb4e63d8ef2db33ac7682b7f73f9cf59a96e36893df63a1056a026a2a41c  bitsongd-linux-arm64.tar.gz
```

### Using Cosmovisor 
```sh
mkdir -P $DAEMON_HOME/cosmovisor/upgrades/v0_18_0/bin && mv build $DAEMON_HOME/cosmovisor/upgrades/v0_18_0/bin 

$DAEMON_HOME/cosmovisor/upgrades/v0_18_0/bin/bitsongd version
```