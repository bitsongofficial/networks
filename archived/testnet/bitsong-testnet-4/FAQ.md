# BitSong testnet-4 checklist

## 1. Go-BitSong Version

```
bitsongd version --long
```

Should produce an output like this

```
$ bitsongd version --long
name: go-bitsong
server_name: bitsongd
client_name: bitsongcli
version: 0.6.0-beta1
commit: ed1332e344a28984e5bce8e4b87ea6597aa6384c
build_tags: netgo,ledger
go: go version go1.14.2 linux/amd64 # This depend on your go version
```

The most important values are

```
version: 0.6.0-beta1
commit: ed1332e344a28984e5bce8e4b87ea6597aa6384c
```

## 2. Genesis checksum

```
shasum -a 256 ~/.bitsongd/config/genesis.json
```

Should produce an output like this

```
$ shasum -a 256 ~/.bitsongd/config/genesis.json
e41be4d3de2ac1966bd4247d19229f64b1b0bd35fdefcae5316d1c36662b716e  /home/angelo/.bitsongd/config/genesis.json
```

The most important value is the shasum

```
e41be4d3de2ac1966bd4247d19229f64b1b0bd35fdefcae5316d1c36662b716e
```

## 3. Is my validator present in genesis?

Assuming that my key is `bitsong1scxs6jght7z52x6y0unygty8mdf8npdetle338` the command will be

```
grep -Ri bitsong1scxs6jght7z52x6y0unygty8mdf8npdetle338 ~/.bitsongd/config/genesis.json
```

Should produce an output like this

```
$ grep -Ri bitsong1scxs6jght7z52x6y0unygty8mdf8npdetle338 ~/.bitsongd/config/genesis.json
                  "delegator_address": "bitsong1scxs6jght7z52x6y0unygty8mdf8npdetle338",
            "address": "bitsong1scxs6jght7z52x6y0unygty8mdf8npdetle338",

```

## 4. Is my node up?

If you used systemd you could use the command `sudo journalctl -u bitsongd -f`

Should produce an output like this

```
I[2020-10-16|12:19:48.221] starting ABCI with Tendermint                module=main
```

## 5. Add seeds

List of public seeds

```
6190e5e52eea8e676c5c4e8f9c7830afcc4ffbf9@37.120.178.44:26656
65fb280c387a55e36b4a2cea774bb3e4f6a10081@172.104.136.83:26656
5f13d0373781effbf87608be9da8021f755fc03e@35.192.159.190:26656
6de901ea0a01450939ac960019ad77bc04ccc228@176.37.214.146:26656
72060750a8ebae54bb169f3f6124a6906974bf39@207.154.237.221:26656
ef8b1520a43f34c5eeff3b675d6e6c42a2750f41@159.89.1.177:26656
61aff01468b90bc1edff94c384639764d5c0b8d6@35.184.73.176:26656
2ea686121879c5e38efbd80ae2d59fa0dc1d8e17@159.89.110.77:26656
ebec86c3283263d5cd5c4944eee2645b3e5649e1@45.239.19.7:26656
c85bd4793e8c56fbcd3183875a4733ddc8a11046@129.213.52.33:27656
209b95486552016d8efd91d46323439d0498df09@144.91.123.104:26656
7f9edf97a353aca41b1af74b8897a7a5fc15665a@135.181.59.225:26656
```

nano `~/.bitsongd/config/config.toml`

```
seeds = "6190e5e52eea8e676c5c4e8f9c7830afcc4ffbf9@37.120.178.44:26656,65fb280c387a55e36b4a2cea774bb3e4f6a10081@172.104.136.83:26656,5f13d0373781effbf87608be9da8021f755fc03e@35.192.159.190:26656,6de901ea0a01450939ac960019ad77bc04ccc228@176.37.214.146:26656,72060750a8ebae54bb169f3f6124a6906974bf39@207.154.237.221:26656,ef8b1520a43f34c5eeff3b675d6e6c42a2750f41@159.89.1.177:26656,61aff01468b90bc1edff94c384639764d5c0b8d6@35.184.73.176:26656,2ea686121879c5e38efbd80ae2d59fa0dc1d8e17@159.89.110.77:26656,ebec86c3283263d5cd5c4944eee2645b3e5649e1@45.239.19.7:26656,c85bd4793e8c56fbcd3183875a4733ddc8a11046@129.213.52.33:27656,209b95486552016d8efd91d46323439d0498df09@144.91.123.104:26656,7f9edf97a353aca41b1af74b8897a7a5fc15665a@135.181.59.225:26656"
```

## 6. Gas fees

To avoid spam, we suggest to set the minimum fee, nano `~/.bitsongd/config/app.toml`

```
minimum-gas-prices = "0.25ubtsg"
```

## 7. RPC

nano `~/.bitsongd/config/config.toml`

```
[rpc]

# TCP or UNIX socket address for the RPC server to listen on
laddr = "tcp://127.0.0.1:26657"
```

## 8. Useful commands

### Check prevotes

```bash
curl -s localhost:26657/consensus_state | jq -r ".result.round_state.height_vote_set[].prevotes_bit_array"
```

### Numbers of connected peers

```bash
curl -s localhost:26657/net_info | grep n_peers
```

### Check if you voted

```bash
curl localhost:26657/consensus_state -s | grep $(bitsongcli status | jq -r .validator_info.address[:12])
```

### Check your validator address

```bash
bitsongcli status | jq ".validator_info.address"
```

### List of connected peers

```bash
curl -s http://localhost:26657/net_info 3 |grep moniker
```

### Check your voting power

```bash
bitsongcli status | jq ".validator_info.voting_power"
```
