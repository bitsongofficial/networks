# bitsong-2b

Inside this repository you can find the Big Bang Upgrade Guide to bitsong-2b and the genesis for the full nodes.

- [Upgrade Guide](./UPGRADE.md)
- [Genesis](./genesis.json)

## Full-Node Setup
- Install useful packages 
```
sudo apt update 
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils -y < "/dev/null"
```
- Install go language
```
wget -O go1.17.1.linux-amd64.tar.gz https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz && rm go1.17.1.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
echo 'export GO111MODULE=on' >> $HOME/.bash_profile
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
```
You can check your installation by running `go version`.  
It should return `go version go1.17.1 linux/amd64`

- Download Bitsong binary
```
git clone https://github.com/bitsongofficial/go-bitsong.git
```
- Move to go-bitsong directory, checkout in v0.8.0 branch then install the binary
```
cd go-bitsong/
git checkout v0.8.0
make install
```
- Init your node and get the correct genesis.json file
```
bitsongd init YOUR-MONIKER --chain-id bitsong-2b
wget https://github.com/bitsongofficial/networks/raw/master/bitsong-2b/genesis.json -O ~/.bitsongd/config/genesis.json
```
- Fill right persistent peers
```
persistent_peers="a62038142844828483dbf16fa6dd159f6857c81b@173.212.247.98:26656,e9fea0509b1a2d16a10ef9fdea0a4e3edc7ca485@185.144.83.158:26656,8208adac8b09f3e2499dfaef24bb89a2d190a7a3@164.68.109.246:26656,cf031ac1cf44c9c311b5967712899391a434da9a@161.97.97.61:26656,d6b2ae82c38927fa7b7630346bd84772e632983a@157.90.95.104:15631,a5885669c1f7860bfe28071a7ec00cc45b2fcbc3@144.91.85.56:26656,325a5920a614e2375fea90f8a08d8b8d612fdd1e@137.74.18.30:26656,ae2787a337c3599b16410f3ac09d6918da2e5c37@46.101.238.149:26656,9336f75cd99ff6e5cdb6335e8d1a2c91b81d84b9@65.21.0.232:26656,9c6e52e78f112a55146b09110d1d1be47702df27@135.181.211.184:36656"
sed -i.bak -e "s/^persistent_peers = \"\"/persistent_peers = \"$persistent_peers\"/" $HOME/.bitsongd/config/config.toml
```
- Fill right seeds
```
seeds="ffa27441ca78a5d41a36f6d505b67a145fd54d8a@95.217.156.228:26656,efd52c1e56b460b1f37d73c8d2bd5f860b41d2ba@65.21.62.83:26656"
sed -i.bak -e "s/^seeds = \"\"/seeds = \"$seeds\"/" $HOME/.bitsongd/config/config.toml
```
- Start your node
```
bitsongd start
```
## Create your validator
Once you have your full node well settled you can create your validator. 
- Create a wallet for your validator
```
bitsongd keys add WALLET-NAME
```
(!! Don't forget to save your mnemonic in a safe place !!)

- Create your validator.   
Your node have to be fully synchronized in order to create your validator.   
You can check it with 
```
curl localhost:26657/status | grep catching_up
```
If this command return false then you can create your validator. Otherwise wait to be fully synchronized.   
Finaly run create-validator command
```
bitsongd tx staking create-validator \ 
--amount=100000000ubtsg \ 
--pubkey=$(bitsongd tendermint show-validator) \ 
--moniker="YOUR MONIKER" \ 
--chain-id=bitsong-2b \ 
--commission-rate="0" \ 
--commission-max-rate="0.20" \ 
--commission-max-change-rate="0.10" \ 
--min-self-delegation="1" \
--from=YOUR-WALLET
```
## Setup a service
Setup a service can be very useful as your validator has to be running everytime.  
You can setup it very easly
```
vi /etc/systemd/system/bitsong.service
[Unit]
Description=Bitsong Node
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/bitsongd start 
Restart=always
RestartSec=3
LimitNOFILE=4096
```
Then run
```
systemctl daemon-reload
systemctl start bitsong
```
You can check your logs to monitor what happend in background by execute:
```
journalctl -u bitsong -f
```
