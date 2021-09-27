## BitSong 1 to 2 genesis modifier to a single validator

1. `bitsong-1-export.json` - Have been exported by using the command `bitsongd export --height 2482860 --for-zero-height > bitsong-1-export.json`
2. `bitsong-1-migrated.json` - Have been made by using the new `go-bitsong v0.42.x`, by using the command `bitsongd migrate bitsong-1-export.json --chain-id=bitsong-testnet-6 --log_level info > bitsong-1-migrated.json`
3. `genesis.test.json` - The genesis that we are using in out test, have been made by using the script `node migrate.js`

# Install and test

## Update Ubuntu

```
apt update && apt upgrade -y
apt install build-essential git jq -y
```

## Download and install go

```
wget https://dl.google.com/go/go1.16.8.linux-amd64.tar.gz
sudo tar -xvzf go1.16.8.linux-amd64.tar.gz
sudo mv go /usr/local

cat <<EOF >> ~/.profile
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
```

```
source ~/.profile
```

## Install `go-bitsong`

```
git clone https://github.com/bitsongofficial/go-bitsong.git && cd go-bitsong

git checkout v0.8.0-rc1

make install

bitsongd version # 0.8.0-rc1
```

## Init and start `go-bitsong`

```
bitsongd init <moniker> --chain-id=bitsong-testnet-6
```

### Optional

```
sed -i 's#"tcp://127.0.0.1:26657"#"tcp://0.0.0.0:26657"#g' ~/.bitsongd/config/config.toml
sed -i 's/enable = false/enable = true/g' ~/.bitsongd/config/app.toml
sed -i 's/swagger = false/swagger = true/g' ~/.bitsongd/config/app.toml
```

### Download the genesis

```
wget https://github.com/bitsongofficial/networks/raw/master/bitsong-testnet-6/genesis.json -O ~/.bitsongd/config/genesis.json
```

### Genesis checksum

```
jq -S -c -M '' ~/.bitsongd/config/genesis.json | shasum -a 256
```

result `d31829db56a7cda63cb2c75bd6e7309c8aa06b94fd8af70bac478400e8bbc637 -`

### Add peers

```
sed -i 's#persistent_peers = ""#persistent_peers = "795f1c85e983f70d7e4834be37828f9ba036cfdf@94.130.111.95:26656"#g' ~/.bitsongd/config/config.toml
```

### Setup Cosmovisor

In order to do automatic on-chain upgrades we will be using cosmovisor. Read more here: https://docs.cosmos.network/master/run-node/cosmovisor.html

```
# download the cosmovisor binary
cd ~ && go get github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor

# check the version
cosmovisor version

# (it should print DAEMON_NAME is not set)
```

Setup env

```
echo "# Setup Cosmovisor" >> ~/.profile
echo "export DAEMON_NAME=bitsongd" >> ~/.profile
echo "export DAEMON_HOME=$HOME/.bitsongd" >> ~/.profile
```

```
source ~/.profile

# verify by running the following
echo $DAEMON_NAME
```

Copy files

```
mkdir -p ~/.bitsongd/cosmovisor/upgrades
mkdir -p ~/.bitsongd/cosmovisor/genesis/bin/
cp $(which bitsongd) ~/.bitsongd/cosmovisor/genesis/bin/
```

```
cosmovisor version
# 0.8.0-rc1
```

### Start

```
cosmovisor start --x-crisis-skip-assert-invariants --pruning=nothing
```

### Optional: Background service

This will allow the node to run in the background and restart automatically.

```
sudo tee /etc/systemd/system/bitsongd.service > /dev/null <<EOF
[Unit]
Description=BitSong Daemon
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/cosmovisor start --x-crisis-skip-assert-invariants --pruning=nothing
Restart=always
RestartSec=3
LimitNOFILE=4096

Environment="DAEMON_HOME=/root/.bitsongd"
Environment="DAEMON_NAME=bitsongd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"

[Install]
WantedBy=multi-user.target
EOF
```

Enable and start it

```
systemctl enable bitsongd && systemctl start bitsongd
```

See logs

```
journalctl -u bitsongd -f
```

## Launch your validator

1. import your mainnet (`bitsong-1`) key

```
bitsongd keys add <key-name> --recover
```

2. create and send `create-validator` tx

```
bitsongd tx staking create-validator \
--amount=10000000ubtsg \
--pubkey=$(bitsongd tendermint show-validator) \
--moniker=<your-moniker> \
--chain-id=bitsong-testnet-6 \
--commission-rate="0.1" \
--commission-max-rate="1.00" \
--commission-max-change-rate="1.00" \
--min-self-delegation="1" \
--gas="auto" \
--gas-adjustment="1.2" \
--gas-prices="0.025ubtsg" \
--from=<key-name>
```
