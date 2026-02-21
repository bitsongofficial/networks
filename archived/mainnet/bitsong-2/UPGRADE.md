# BitSong 2 Instructions

## Upgrade procedure

1. Verify that you are currently running the correct version (v0.7.0) of `bitsongd`:
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

2. Make sure your chain halts at the right block: `2966150`
```
perl -i -pe 's/^halt-height =.*/halt-height = 2966150/' ~/.bitsongd/config/app.toml
```
then restart your node `systemctl restart bitsongd`

3. After the chain has halted, make a backup of your `.bitsongd` and `.bitsongcli` directory
```
cp -Rf ~/.bitsongcli ./bitsongcli_backup
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-1`.

4. Export existing state from `bitsong-1`

Before exporting state via the following command, the **bitsongd** binary must be stopped! As a validator, you can see the last block height created in the `~/.bitsongd/data/priv_validator_state.json` - or now residing in `bitsongd_backup` when you made a backup as in the last step - and obtain it with

```
cat ~/.bitsongd/data/priv_validator_state.json | jq '.height'
```

```
bitsongd export --height=2966150 > bitsong_1_genesis_export.json
```

5. Verify the SHA256 of the (sorted) exported genesis file:

Compare this value with other validators / full node operators of the network. Going forward it will be important that all parties can create the same genesis file export.

```
$ jq -S -c -M '' bitsong_1_genesis_export.json | shasum -a 256
98684b8321c9b9c65d1ce4783d4d6f163291fb90ebcd604d04a95413526321f9  bitsong_1_genesis_export.json
```

6. At this point you now have a valid exported genesis state! All further steps now require v0.8.0 of `go-bitsong`. Cross check your genesis hash with other peers (other validators) in the chat rooms.

**NOTE**: Go 1.16+ is required!

```
$ git clone https://github.com/bitsongofficial/go-bitsong.git && cd go-bitsong && git checkout v0.8.0; make install
```

7. Verify you are currently running the correct version (v0.8.0) of the `go-bitsong`:

```
name: go-bitsong
server_name: <appd>
version: 0.8.0
commit: 6ab1a183e6a589a02ad8958a95f7eed0e2362a97
build_tags: netgo,ledger
go: go version go1.16.8 linux/amd64
```

The version/commit hash of go-bitsong v0.8.0: `6ab1a183e6a589a02ad8958a95f7eed0e2362a97`

8. Migrate exported state from the current v0.7.0 version to the new v0.8.0 version:

```
$ bitsongd migrate bitsong_1_genesis_export.json --chain-id=bitsong-2 --initial-height 2966151 > genesis.json
```

This will migrate our exported state into the required `genesis.json` file to start the `bitsong-2`.

9. Verify the SHA256 of the final genesis JSON:
```
$ jq -S -c -M '' genesis.json | shasum -a 256
849bf36937e26a0f12a9c5e5e8d99461328cd6e7205767b6861c9e4442bd503d  genesis.json
```

Compare this value with other validators / full node operators of the network. It is important that each party can reproduce the same genesis.json file from the steps accordingly.

10. Reset state:

**NOTE:** Be sure you have a complete backed up state of your node before proceeding with this step.

```
$ bitsongd unsafe-reset-all
```

11. Move the new `genesis.json` to your `.bitsongd/config/` directory

```
cp genesis.json ~/.bitsongd/config/
```

12. Start `go-bitsong`

```
$ bitsongd start
```

Automated audits of the genesis state can take some minutes using the crisis module. This can be disabled by `bitsongd start --x-crisis-skip-assert-invariants`

## Guidance for Full Node Operators

1. Verify you are currently running the correct version (v0.7.0) of `go-bitsong`:

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

2. Stop your `go-bitsong v0.7.0` instance.

3. After the chain has halted, make a backup of your `.bitsongd` directory

```
cp -Rf ~/.bitsongcli ./bitsongcli_backup
cp -Rf ~/.bitsongd ./bitsongd_backup
```

**NOTE**: It is recommended for validators and operators to take a full data snapshot at the export height before proceeding in case the upgrade does not go as planned or if not enough voting power comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback to continue operating `bitsong-1`.

4. Install `go-bitsong v0.8.0`
**NOTE**: Go 1.16+ is required!

```
$ git clone https://github.com/bitsongofficial/go-bitsong.git && cd go-bitsong && git checkout v0.8.0; make install
```

5. Verify you are currently running the correct version (v0.8.0) of the `go-bitsong`:

```
name: go-bitsong
server_name: <appd>
version: 0.8.0
commit: 6ab1a183e6a589a02ad8958a95f7eed0e2362a97
build_tags: netgo,ledger
go: go version go1.16.8 linux/amd64
```

The version/commit hash of go-bitsong v0.8.0: `6ab1a183e6a589a02ad8958a95f7eed0e2362a97`

6. Reset state:

**NOTE:** Be sure you have a complete backed up state of your node before proceeding with this step

```
bitsongd unsafe-reset-all
```

7. Download the `bitsong-2` genesis file from the [BitSong Networks Repo](https://github.com/bitsongofficial/networks/tree/master/bitsong-2). This file will be generated by a validator that is migrating from `bitsong-1` to `bitsong-2`. The `bitsong-2` genesis file will be validated by community participants, and the hash of the file will be shared on the #validators channel of the BitSong Discord.

```
wget https://github.com/bitsongofficial/networks/raw/master/bitsong-2/genesis.json -O ~/.bitsongd/config/genesis.json
```

8. Start `go-bitsong`

```
bitsongd start
```

Automated audits of the genesis state can take some minutes using the crisis module. This can be disabled by `bitsongd start --x-crisis-skip-assert-invariants`

## Notes for Service Providers

### REST server

In case you have been running REST server with the command `bitsongcli rest-server`  previously, running this command will not be necessary anymore. API server is now in-process with daemon and can be enabled/disabled by API configuration in your `.bitsongd/config/app.toml`

```
[api]
# Enable defines if the API server should be enabled.
enable = false
# Swagger defines if swagger documentation should automatically be registered.
swagger = false
```

`swagger` setting refers to enabling/disabling swagger docs API, i.e, /swagger/ API endpoint.

### gRPC Configuration

gRPC configuration in your `.bitsongd/config/app.toml`

```
[grpc]
# Enable defines if the gRPC server should be enabled.
enable = true
# Address defines the gRPC server address to bind to.
address = "0.0.0.0:9090"
```

### State Sync

State Sync Configuration in your `.bitsongd/config/app.toml`

```
# State sync snapshots allow other nodes to rapidly join the network without replaying historical
# blocks, instead downloading and applying a snapshot of the application state at a given height.
[state-sync]
# snapshot-interval specifies the block interval at which local state sync snapshots are
# taken (0 to disable). Must be a multiple of pruning-keep-every.
snapshot-interval = 0
# snapshot-keep-recent specifies the number of recent snapshots to keep and serve (0 to keep all).
snapshot-keep-recent = 2
```
