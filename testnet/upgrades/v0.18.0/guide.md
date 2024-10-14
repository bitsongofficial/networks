# Go-Bitsong v0.18.0 - Babberitus
|                 |                                                              |
|-----------------|--------------------------------------------------------------|
| Chain-id        | `bitsong-2b`                                                  |
| Upgrade Version | `v0.18.0`                                                     |
| Upgrade Height  | `TBD`                                                    |



The target block for this upgrade is `TBD`, which is expected to arrive at 3:00 UTC Tuesday, Oct 22nd [Go Playground](https://go.dev/play/p/)

## Building Manually:

### 1. Verify that you are currently running the correct version (v0.17.0) of `bitsongd`:
```
bitsongd version --long
name: go-bitsong
server_name: bitsongd
client_name: bitsongcli
version: 0.7.0
commit: 26a277a67b8d3e0052ace21be7f3a2754171b06b
build_tags: netgo,ledger
go: go version go1.13.15 linux/amd64
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


### 4. Install new Go-Bitsong binary

```
cd go-bitsong && git pull && git checkout v0.18.0
make build && make install 
```

### 5. Verify you are currently running the correct version (v0.8.0) of the `go-bitsong`:
```
bitsongd version --long | grep "cosmos_sdk_veresion/|commit\|version:"
# commit: 
# cosmos_sdk_version: v0.47.8
# version: 0.18.0

```
### Downloading Verified Build:
```sh
rm -rf terpd_linux_amd64.tar.gz # delete if exists
wget https://github.com/bitsongofficial/go-bitsong/releases/download/v0.18.0/bitsongd-linux-amd64.tar.gz
sha256sum bitsongd-linux-amd64.tar.gz
# Output  TBD  bitsongd-linux-amd64.tar.gz
# Output  TBD  bitsongd-linux-arm64.tar.gz
```

### Using Cosmovisor 
```sh
mkdir -P $DAEMON_HOME/cosmovisor/upgrades/v0_18_0/bin && mv build $DAEMON_HOME/cosmovisor/upgrades/v0_18_0/bin 

$DAEMON_HOME/cosmovisor/upgrades/v0_18_0/bin/bitsongd version
```